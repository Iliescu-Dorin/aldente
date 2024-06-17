import 'package:aldente/models/doctor.dart';
import 'package:aldente/models/user.dart';
import 'package:aldente/modules/doctorhome/doctorhome_controller.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DoctorHome extends GetView<DoctorHomeController> {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.onLogoutTap,
          )
        ],
      ),
      body: FutureBuilder<Doctor>(
        future: PocketbaseService.to.getCurrentDoctorProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final doctor = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<User>(
                      future: PocketbaseService.to
                          .getUserDetails(doctor!.doctorId!),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: user?.avatar != null
                                  ? NetworkImage(user!.avatar!)
                                  : const AssetImage(
                                          'assets/icons/eye_specialist.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Welcome, Dr. ${user?.name ?? ''}!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Doctor Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Rating: ${doctor.rating ?? 'N/A'}'),
                            const SizedBox(height: 8),
                            Text(
                                'Years of Experience: ${doctor.yearsOfExperience ?? 'N/A'}'),
                            const SizedBox(height: 8),
                            Text(
                              'Specialties: ${doctor.specialties?.map((specialty) => specialty.name).join(', ') ?? 'N/A'}',
                            ),
                                
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upcoming Appointments',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Add a list of upcoming appointments here
                            // You can use a ListView.builder or a similar widget to display the appointments
                            // Example:
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: upcomingAppointments.length,
                            //   itemBuilder: (context, index) {
                            //     final appointment = upcomingAppointments[index];
                            //     return ListTile(
                            //       title: Text(appointment.patientName),
                            //       subtitle: Text(appointment.date),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Reviews',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Add a list of patient reviews here
                            // You can use a ListView.builder or a similar widget to display the reviews
                            // Example:
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: patientReviews.length,
                            //   itemBuilder: (context, index) {
                            //     final review = patientReviews[index];
                            //     return ListTile(
                            //       title: Text(review.patientName),
                            //       subtitle: Text(review.comment),
                            //       trailing: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           Icon(Icons.star, color: Colors.amber),
                            //           Text(review.rating.toString()),
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analytics',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Add analytics widgets or charts here
                            // You can use libraries like fl_chart or charts_flutter to display graphs and charts
                            // Example:
                            // BarChart(
                            //   BarChartData(
                            //     // Add data for the bar chart
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

