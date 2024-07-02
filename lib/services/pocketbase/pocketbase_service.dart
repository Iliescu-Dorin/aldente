import 'dart:convert';
import 'dart:io';
import 'package:aldente/data/helper.dart';
import 'package:aldente/data/message_builder.dart';
import 'package:aldente/exceptions/auth_exception.dart';
import 'package:aldente/models/appointment.dart';
import 'package:aldente/models/chat_room.dart';
import 'package:aldente/models/client.dart';
import 'package:aldente/models/doctor.dart';
import 'package:aldente/models/specialty.dart';
import 'package:aldente/models/user.dart';
import 'package:aldente/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class PocketbaseService extends GetxService {
  static PocketbaseService get to => Get.find();

  final _pocketBaseUrl = "http://192.168.0.188:8090";
  late PocketBase _client;
  late AuthStore _authStore;
  late String _temporaryDirectory;
  final _httpClient = HttpClient();
  final _cachedUsersData = <String, User>{};
  User? user;

  bool get isAuth => user != null;

  Future<PocketbaseService> init() async {
    _temporaryDirectory = (await getTemporaryDirectory()).path;
    _initializeAuthStore();
    _client = PocketBase(_pocketBaseUrl, authStore: _authStore);
    _setupAuthListener();
    return this;
  }

  void _initializeAuthStore() {
    _authStore = AuthStore();
    user = StorageService.to.user;
    if (user?.token != null) {
      _authStore.save(user!.token!, RecordModel.fromJson(user!.toJson()));
    }
  }

  void _setupAuthListener() {
    _client.authStore.onChange.listen((AuthStoreEvent event) {
      if (event.model is RecordModel) {
        user = User.fromJson(event.model.toJson())..token = event.token;
        StorageService.to.user = user;
      }
    });
  }

  // Message-related methods
  Future<void> sendMessage(String roomId, Message message) async {
    try {
      var result = await _client.collection('messages').create(
            body: MessageBuilder.parseMessageToJson(roomId, message),
            files: MessageBuilder.parseMessageToMultipart(message),
          );
      await _client
          .collection('rooms')
          .update(roomId, body: {'chat_id': result.id});
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<List<Message>> getMessages(
      {required String? roomId, String? chatId}) async {
    if (roomId == null) return [];
    try {
      String filterString =
          chatId != null ? "id = '$chatId'" : "room_id = '$roomId'";
      ResultList result =
          await _client.collection('messages').getList(filter: filterString);
      return Future.wait(result.items
          .map((e) => MessageBuilder.parseJsonToMessage(e.toJson(), e)));
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<UnsubscribeFunc> subscribeToChatUpdates({
    required String roomId,
    required Function(Message) onChat,
  }) {
    return _client.collection('rooms').subscribe(roomId,
        (RecordSubscriptionEvent event) async {
      String? chatId = ChatRoom.fromJson(event.record?.toJson() ?? {}).chatId;
      if (chatId != null) {
        List<Message> chats = await getMessages(roomId: roomId, chatId: chatId);
        if (chats.isNotEmpty) onChat(chats.first);
      }
    });
  }

  // Room-related methods
  Future<List<ChatRoom>> getRooms() async {
    try {
      ResultList result = await _client.collection('rooms').getList();
      return result.items.map((e) => ChatRoom.fromJson(e.toJson())).toList();
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<void> addRoom(String room, String userId) async {
    try {
      await _client
          .collection('rooms')
          .create(body: {'name': room, "created_by": userId});
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await _client.collection('rooms').delete(roomId);
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  // Auth-related methods
  Future<RecordAuth> login(String email, String password) async {
    try {
      return await _client
          .collection('users')
          .authWithPassword(email, password);
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<RecordModel> signUp(String name, String email, String password) async {
    try {
      return await _client.collection('users').create(body: {
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "name": name,
        "emailVisibility": true,
      });
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<void> logout() async {
    _client.authStore.clear();
    StorageService.to.user = null;
  }

  Future<User> getUserDetails(String userId, {bool useCache = false}) async {
    try {
      if (useCache && _cachedUsersData.containsKey(userId)) {
        return _cachedUsersData[userId]!;
      }
      final result = await _client.collection('users').getOne(userId);
      var user = User.fromJson(result.toJson());
      user.avatar = getAvatarUrl(result);
      _cachedUsersData[userId] = user;
      return user;
    } on ClientException catch (e) {
      Get.log(e.toString());
      throw e.errorMessage;
    }
  }

  // Appointment-related methods
  Future<List<Appointment>> getAppointmentsByDoctorId(String doctorId) async {
    final result = await _client.collection('Appointment').getFullList(
          filter: 'doctor_id = "$doctorId"',
        );
    return result
        .map((record) => Appointment.fromJson(record.toJson()))
        .toList();
  }

  Future<Appointment> createAppointment(
      Map<String, dynamic> appointmentData) async {
    try {
      final createdAppointment =
          await _client.collection('Appointment').create(body: appointmentData);
      return Appointment.fromJson(createdAppointment.data);
    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    }
  }

  Future<Client> getCurrentClientProfile({bool useCache = false}) async {
    final userId = user?.id;
    if (userId == null) {
      throw Exception('User ID is null');
    }

    try {
      final result = await _client.collection('Client').getFullList(
            filter: 'user_id = "$userId"',
          );

      return Client.fromJson(result.first.toJson());
    } catch (e) {
      throw Exception('Failed to fetch client profile: ${e.toString()}');
    }
  }

  // Doctor-related methods
  Future<Doctor>? getCurrentDoctorProfile({bool useCache = false}) async {
    var userId = user!.id!;
    final result = await _client.collection('Doctor').getFullList(
          filter: 'doctor_id = "$userId"',
          expand: 'specialty_id',
        );

    final doctorJson = result.first.toJson();
    final doctor = Doctor.fromJson(doctorJson);
    final specialtyJsonList =
        doctorJson['expand']?['specialty_id'] as List<dynamic>?;
    if (specialtyJsonList != null) {
      doctor.specialties = specialtyJsonList
          .map((specialtyJson) => Specialty.fromJson(specialtyJson))
          .toList();
    }
    return doctor;
  }

  Future<List<Specialty>> getSpecialtiesByIds(
      List<String>? specialtyIds) async {
    if (specialtyIds == null || specialtyIds.isEmpty) return [];
    return Future.wait(specialtyIds
        .map(getSpecialtyById)
        .where((specialty) => specialty != null)
        .cast<Specialty>() as Iterable<Future<Specialty>>);
  }

  Future<Specialty?> getSpecialtyById(String specialtyId) async {
    try {
      final record =
          await _client.collection('specialties').getOne(specialtyId);
      return Specialty.fromJson(record.toJson());
    } catch (e) {
      print('Error fetching specialty: $e');
      return null;
    }
  }

  // Helper methods
  Uri getFileUrl(RecordModel recordModel, String fileName) =>
      _client.getFileUrl(recordModel, fileName);

  Future<File?> downloadFile({
    required RecordModel recordModel,
    required String fileName,
    bool useCache = false,
  }) async {
    try {
      Uri fileUri = _client.getFileUrl(recordModel, fileName);
      File file = File('$_temporaryDirectory/$fileName');
      if (useCache && file.existsSync()) return file;
      var request = await _httpClient.getUrl(fileUri);
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      return await file.writeAsBytes(bytes);
    } catch (error) {
      return null;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final result = await _client.collection('users').getOne(user!.id!);
      final userData = User.fromJson(result.toJson());
      return userData.role;
    } on ClientException catch (e) {
      Get.log(e.toString());
      return null;
    } catch (e) {
      Get.log(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getMarkers() async {
    try {
      final clinics = await _client.collection('clinic').getFullList(
            sort: '-created',
            expand: 'doctors,clinic_id',
          );

      final markers = await Future.wait(clinics.map(_processClinicRecord));
      return markers.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      Get.log("Error fetching clinic markers: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> _processClinicRecord(RecordModel clinic) async {
    final address = clinic.getStringValue('address');
    final coordinates = await _getCoordinatesFromAddress(address);

    if (coordinates == null) return null;

    final clinicUser = clinic.expand['clinic_id'];
    final RecordModel? user = clinicUser is List
        ? (clinicUser!.isNotEmpty ? clinicUser.first : null)
        : (clinicUser as RecordModel?);

    return {
      'id': clinic.id,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'title': clinic.getStringValue('collectionName'),
      'details': _formatClinicDetails(clinic, user),
      'avatarUrl': getAvatarUrl(user),
      'phone_number': clinic.getStringValue('phone_number'),
      'doctors': clinic.getListValue('doctors'),
      'email': user?.getStringValue('email'),
      'name': user?.getStringValue('name'),
    };
  }

  String _formatClinicDetails(RecordModel clinic, RecordModel? clinicUser) {
    return '''
    Name: ${clinicUser?.getStringValue('name') ?? 'N/A'}
    Email: ${clinicUser?.getStringValue('email') ?? 'N/A'}
    Address: ${clinic.getStringValue('address')}
    Phone: ${clinic.getStringValue('phone_number')}
    Doctors: ${clinic.getListValue('doctors').length}
    ''';
  }

  String? getAvatarUrl(RecordModel? user) {
    if (user == null) return null;

    final avatarFileName = user.getStringValue('avatar');
    if (avatarFileName.isEmpty) return null;

    final collectionId = user.collectionId;
    final recordId = user.id;

    return '$_pocketBaseUrl/api/files/$collectionId/$recordId/$avatarFileName';
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=$encodedAddress';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      Get.log('Error geocoding address: $e');
    }
    return null;
  }

  Future<void> authWithOAuth2(
    String provider,
    Function(Uri) accessToken,
    String? idToken,
    String? email,
    String? name,
  ) async {
    try {
      final authData = await _client.collection('users').authWithOAuth2(
        provider,
        (url) => accessToken,
        createData: {
          'email': email,
          'name': name,
          'role': 'client', // Set the role to 'client' for new users
        },
      );

      // If the user already exists, update their role to 'client'
      if (authData.record != null &&
          authData.record!.data['role'] != 'client') {
        await _client.collection('users').update(authData.record!.id, body: {
          'role': 'client',
        });
      }

      // Handle the authenticated user data as needed
      print('Authenticated user: ${authData.record}');
    } catch (e) {
      print('OAuth2 authentication error: $e');
      throw AuthException(
          'Failed to authenticate with OAuth2: ${e.toString()}');
    }
  }
}
