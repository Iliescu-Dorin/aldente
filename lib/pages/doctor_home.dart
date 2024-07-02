import 'package:aldente/models/appointment.dart';
import 'package:aldente/models/doctor.dart';
import 'package:aldente/models/user.dart';
import 'package:aldente/modules/doctorhome/doctorhome_controller.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:booking_calendar/booking_calendar.dart';

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
            final doctor = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorInfoWidget(doctorId: doctor.doctorId!),
                    const SizedBox(height: 24),
                    DoctorDetailsWidget(doctor: doctor),
                    const SizedBox(height: 24),
                    const UpcomingAppointmentsWidget(),
                    const SizedBox(height: 24),
                    const PatientReviewsWidget(),
                    const SizedBox(height: 24),
                    AppointmentCalendarWidget(doctorId: doctor.id!),
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

class DoctorInfoWidget extends StatelessWidget {
  final String doctorId;

  const DoctorInfoWidget({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: PocketbaseService.to.getUserDetails(doctorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data!;
          return Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.avatar != null
                    ? NetworkImage(user.avatar!)
                    : const AssetImage('assets/icons/eye_specialist.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Welcome, Dr. ${user.name ?? ''}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class DoctorDetailsWidget extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text('Years of Experience: ${doctor.yearsOfExperience ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text(
              'Specialties: ${doctor.specialties?.map((specialty) => specialty.name).join(', ') ?? 'N/A'}',
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingAppointmentsWidget extends StatelessWidget {
  const UpcomingAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
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
          ],
        ),
      ),
    );
  }
}

class PatientReviewsWidget extends StatelessWidget {
  const PatientReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
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
          ],
        ),
      ),
    );
  }
}



class AppointmentCalendarWidget extends StatelessWidget {
  final String doctorId;

  const AppointmentCalendarWidget({super.key, required this.doctorId});

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Add your booking upload logic here
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    final converted = <DateTimeRange>[];
    // Add your stream result conversion logic here
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    // Add your logic to generate pause slots here
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final mockBookingService = BookingService(
      serviceName: 'Doctor Appointments',
      serviceDuration: 60,
      bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
      bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
    );

    return SizedBox(
      height: 600,
      child: BookingCalendar(
        bookingService: mockBookingService,
        convertStreamResultToDateTimeRanges: convertStreamResultMock,
        getBookingStream: getBookingStreamMock,
        uploadBooking: uploadBookingMock,
        pauseSlots: generatePauseSlots(),
        pauseSlotText: 'LUNCH',
        hideBreakTime: false,
        loadingWidget: const Text('Fetching data...'),
        uploadingWidget: const CircularProgressIndicator(),
        locale: 'en_US',
        startingDayOfWeek: StartingDayOfWeek.sunday,
        wholeDayIsBookedWidget:
            const Text('Sorry, for this day everything is booked'),
        // disabledDates: [DateTime(2023, 1, 20)],
        // disabledDays: [6, 7],
      ),
    );
  }
}
