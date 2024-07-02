import 'package:aldente/src/theme/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aldente/constant.dart';
import 'package:aldente/models/client.dart';
import 'package:aldente/models/user.dart';
import 'package:aldente/pages/chat_doc/chat_screen.dart';
import 'package:aldente/pages/components/app_search_bar.dart';
import 'package:aldente/pages/components/category_card.dart';
import 'package:aldente/pages/components/doctor_card.dart';
import 'package:aldente/services/gemma_service.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:aldente/src/theme/light_color.dart';
import 'package:aldente/src/theme/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Client> _clientFuture;
  Future<User>? _userFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _clientFuture = PocketbaseService.to.getCurrentClientProfile();
    _clientFuture.then((client) {
      setState(() {
        _userFuture = PocketbaseService.to.getUserDetails(client.userId);
      });
    }).catchError((error) {
      print('Error fetching client profile: $error');
      // Handle error (e.g., show a snackbar)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Client>(
          future: _clientFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _buildBody();
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon:
            const Icon(Icons.maps_ugc_outlined, size: 30, color: Colors.black),
        onPressed: _navigateToChatScreen,
      ),
      actions: <Widget>[
        const Icon(Icons.notifications_none, size: 30, color: LightColor.grey),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildUserAvatar(),
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: user.avatar != null
                  ? Image.network(user.avatar!)
                  : SvgPicture.asset('assets/icons/profile.svg'),
            ),
          );
        } else {
          return SvgPicture.asset('assets/icons/profile.svg');
        }
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 30),
          const AppSearchBar(),
          const SizedBox(height: 20),
          _buildSectionTitle('Professional Categories'),
          const SizedBox(height: 20),
          _buildCategoryList(),
          const SizedBox(height: 20),
          _buildSectionTitle('Doctors Near You'),
          const SizedBox(height: 20),
          _buildDoctorList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Hello,", style: TextStyles.title.subTitleColor),
                Text(user.name ?? "User", style: TextStyles.h1Style),
              ],
            ),
          );
        } else {
          return const Text("Welcome");
        }
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: kTitleTextColor,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final List<Map<String, dynamic>> specialties = [
      {'name': 'Radiologist', 'color': kBlueColor},
      {'name': 'Public Health', 'color': kGreenColor},
      {'name': 'Endodontist', 'color': kYellowColor},
      {'name': 'Pathologist', 'color': kOrangeColor},
      {'name': 'Oral Medicine', 'color': kPurpleColor},
      {'name': 'Microbiologist', 'color': kPinkColor},
      {'name': 'Oral Surgeon', 'color': kRedColor},
      {'name': 'Orthodontist', 'color': kTealColor},
      {'name': 'Paediatric', 'color': kLightBlueColor},
      {'name': 'Periodontologist', 'color': kLimeColor},
      {'name': 'Prosthodontist', 'color': kAmberColor},
      {'name': 'Restorative', 'color': kBrownColor},
      {'name': 'Special Care', 'color': kIndigoColor},
    ];

    const String iconPath = 'assets/icons/dental_surgeon.png';

    return SizedBox(
      height: 160, // Adjust this value to fit your design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: specialties.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CategoryCard(
                  specialties[index]['name'],
                  iconPath,
                  specialties[index]['color'],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          DoctorCard('Dr. Emily Chen', 'Orthodontist - Bright Smile Dental',
              'assets/images/doctor1.png', kBlueColor),
          const SizedBox(height: 20),
          DoctorCard(
              'Dr. Michael Rodriguez',
              'Periodontist - Healthy Gums Clinic',
              'assets/images/doctor2.png',
              kYellowColor),
          const SizedBox(height: 20),
          DoctorCard(
              'Dr. Sarah Johnson',
              'Endodontist - Root Canal Specialists',
              'assets/images/doctor3.png',
              kOrangeColor),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _navigateToChatScreen() async {
    try {
      await initializeFlutterGemma();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize chat: $e')),
      );
    }
  }
}
