import 'dart:io';
import 'package:aldente/data/helper.dart';
import 'package:aldente/data/message_builder.dart';
import 'package:aldente/models/chat_room.dart';
import 'package:aldente/models/doctor.dart';
import 'package:aldente/models/specialty.dart';
import 'package:aldente/models/user.dart';
import 'package:aldente/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseService extends GetxService {
  static PocketbaseService get to => Get.find();

  // Replace with your pocketbase url
  final _pocketBaseUrl = "http://192.168.0.199:8090";

  late PocketBase _client;
  late AuthStore _authStore;
  late String _temporaryDirectory;
  final _httpClient = HttpClient();
  final _cachedUsersData = {};
  User? user;
  bool get isAuth => user != null;

  Future<PocketbaseService> init() async {
    _temporaryDirectory = (await getTemporaryDirectory()).path;
    _initializeAuthStore();
    _client = PocketBase(_pocketBaseUrl, authStore: _authStore);
    // Listen to authStore changes
    _client.authStore.onChange.listen((AuthStoreEvent event) {
      if (event.model is RecordModel) {
        user = User.fromJson(event.model.toJson());
        user?.token = event.token;
        StorageService.to.user = user;
      }
    });
    return this;
  }

  void _initializeAuthStore() {
    _authStore = AuthStore();
    user = StorageService.to.user;
    String? token = user?.token;
    if (user == null || token == null) return;
    RecordModel model = RecordModel.fromJson(user!.toJson());
    _authStore.save(token, model);
  }

  /// Messages
  Future sendMessage(String roomId, Message message) async {
    try {
      // add message to database
      var result = await _client.collection('messages').create(
            body: MessageBuilder.parseMessageToJson(roomId, message),
            files: MessageBuilder.parseMessageToMultipart(message),
          );
      // update chatId in room, to trigger chat update
      await _client
          .collection('rooms')
          .update(roomId, body: {'chat_id': result.id});
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<List<Message>> getMessages({
    required String? roomId,
    String? chatId,
  }) async {
    if (roomId == null) return [];
    try {
      String filterString = "room_id = '$roomId'";
      if (chatId != null) filterString = "id = '$chatId'";
      ResultList result =
          await _client.collection('messages').getList(filter: filterString);
      List<Message> messages = [];
      for (var e in result.items) {
        messages.add(await MessageBuilder.parseJsonToMessage(e.toJson(), e));
      }
      return messages;
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future<UnsubscribeFunc> subscribeToChatUpdates({
    required String roomId,
    required Function(Message) onChat,
  }) {
    return _client.collection('rooms').subscribe(roomId, (
      RecordSubscriptionEvent event,
    ) async {
      RecordModel? data = event.record;
      if (data == null) return;
      String? chatId = ChatRoom.fromJson(data.toJson()).chatId;
      if (chatId == null) return;
      List<Message> chats = await getMessages(roomId: roomId, chatId: chatId);
      if (chats.isNotEmpty) onChat(chats.first);
    });
  }

  /// Rooms
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
      await _client.collection('rooms').create(body: {
        'name': room,
        "created_by": userId,
      });
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

  /// Auth
  Future login(String email, String password) async {
    try {
      RecordAuth userData =
          await _client.collection('users').authWithPassword(email, password);
      return userData;
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future signUp(String name, String email, String password) async {
    try {
      final body = <String, dynamic>{
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "name": name,
        "emailVisibility": true,
      };
      return await _client.collection('users').create(body: body);
    } on ClientException catch (e) {
      throw e.errorMessage;
    }
  }

  Future logout() async {
    _client.authStore.clear();
    StorageService.to.user = null;
  }

  Future<User> getUserDetails(
    String userId, {
    bool useCache = false,
  }) async {
    try {
      if (useCache && _cachedUsersData.containsKey(userId)) {
        return _cachedUsersData[userId];
      }
      final result = await _client.collection('users').getOne(userId);
      var user = User.fromJson(result.toJson());
      _cachedUsersData[userId] = user;
      return user;
    } on ClientException catch (e) {
      Get.log(e.toString());
      throw e.errorMessage;
    }
  }

  // Future<Doctor>? getCurrentDoctorProfile({bool useCache = false}) async {
  //   var userId = user!.id!;
  //   final result = await _client.collection('Doctor').getFirstListItem(
  //         'doctor_id = "$userId"',
  //          expand: 'specialty_id',
  //       );

  //   final doctor = Doctor.fromJson(result.toJson());
  //   return doctor;
  // }

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
      final specialties = specialtyJsonList
          .map((specialtyJson) => Specialty.fromJson(specialtyJson))
          .toList();
      doctor.specialties = specialties;
    }
    return doctor;
  }

  Future<List<Specialty>> getSpecialtiesByIds(
      List<String>? specialtyIds) async {
    if (specialtyIds == null || specialtyIds.isEmpty) {
      return [];
    }

    final specialties = <Specialty>[];
    for (final specialtyId in specialtyIds) {
      final specialty = await getSpecialtyById(specialtyId);
      if (specialty != null) {
        specialties.add(specialty);
      }
    }
    return specialties;
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

  /// Helpers
  Uri getFileUrl(RecordModel recordModel, String fileName) =>
      _client.getFileUrl(recordModel, fileName);

  /// Either pass [uri] or [recordModel] to download file
  /// [useCache] will return the cached file if its already downloaded
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

  /// Get user role based on the authenticated user
  Future<String?> getUserRole() async {
    try {
      final result = await _client.collection('users').getOne(user!.id!);
      final userData = User.fromJson(result.toJson());
      return userData.role; // Adjust as per your User model
    } on ClientException catch (e) {
      Get.log(e.toString());
      return null;
    } catch (e) {
      Get.log(e.toString());
      return null;
    }
  }
}
