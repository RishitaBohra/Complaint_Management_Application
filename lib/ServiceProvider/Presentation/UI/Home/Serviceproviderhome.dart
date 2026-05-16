
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/EndProcess/AfterPhoto.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/notifications.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Profile/serviceproviderprofile.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/viewcomplaintdetails.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Completedcomplaints.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/PendingComplaints.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/totalComplaints.dart';
import 'package:amity_university/User/Presentation/model/complaint_model.dart' as model;
import 'package:amity_university/api_service_baseurl.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/StartProcess/OtpScreen.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  const ServiceProviderHomeScreen({super.key});
  @override
  State<ServiceProviderHomeScreen> createState() => _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {

  int pendingComplaints = 0;
  int completedComplaints = 0;
  int totalComplaints = 0;
  int staffId = 0;
  String staffName = "";
  String? profileImageUrl;

  List<dynamic> pendingComplaintList = [];
  bool _isLoading = false;
  bool _isFetching = false;

  late AnimationController _cardAnimationController;
  late AnimationController _summaryAnimationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _summaryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));

    loadStaffDataAndFetchComplaints();
    _summaryAnimationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cardAnimationController.dispose();
    _summaryAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      fetchComplaints();
    }
  }

  Future<void> loadStaffDataAndFetchComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    staffId = prefs.getInt('staffId') ?? 0;
    staffName = prefs.getString('staffName') ?? 'Service Provider';
    profileImageUrl = prefs.getString('profileImage');

    if (staffId != 0) {
      await fetchComplaints(showLoader: true);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Staff ID not found. Please login again."),
          ),
        );
      }
    }
  }

  Future<void> fetchComplaints({bool showLoader = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    if (showLoader) setState(() => _isLoading = true);

    final url = Uri.parse('${baseUrl}api/complaints/by-staff/$staffId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List complaints = jsonResponse['data'];

        if (mounted) {
          setState(() {
            totalComplaints = complaints.length;
            pendingComplaintList = complaints
                .where((c) => c['status'].toString().toLowerCase() == 'pending')
                .toList();
            pendingComplaints = pendingComplaintList.length;
            completedComplaints = complaints
                .where((c) => c['status'].toString().toLowerCase() == 'completed')
                .length;
          });
          _cardAnimationController.forward(from: 0);
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching complaints: $e');
    } finally {
      _isFetching = false;
      if (showLoader && mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: ColorPicker.blueColor,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ServiceProviderProfileScreen()),
                    );
                    if (result == true) loadStaffDataAndFetchComplaints();
                  },
                  child: CircleAvatar(
                    backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? NetworkImage('$uploadsUrl$profileImageUrl')
                        : const AssetImage('assets/logo.png') as ImageProvider,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(staffName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    const Text('Active',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ServiceProviderNotificationScreen()),
                      );
                     
                    },
                  ),
                  
                ],
              ),
            ],
          ),
          body: _buildBody(),
        ),
        if (_isLoading)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isLoading ? 1.0 : 0.0,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComplaintSummary(),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ViewAllComplaints()),
              );
            },
            child: _buildWideBox('Total Complaints', totalComplaints),
          ),
          const SizedBox(height: 20),
          const Text('Pending Complaints:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: pendingComplaintList.isEmpty
                ? const Center(child: Text('No pending complaints found.'))
                : ListView.builder(
                    itemCount: pendingComplaintList.length,
                    itemBuilder: (context, index) {
                      final complaint = pendingComplaintList[index];
                      return SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _cardAnimationController,
                            curve: Interval(0.1 * index, 1.0, curve: Curves.easeIn),
                          ),
                          child: _buildPendingCard(complaint),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScaleTransition(
          scale: CurvedAnimation(parent: _summaryAnimationController, curve: Curves.elasticOut),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewPendingComplaints()),
              );
            },
            child: _buildBoxWithCircle('Pending Complaints', pendingComplaints, isPending: true),
          ),
        ),
        ScaleTransition(
          scale: CurvedAnimation(parent: _summaryAnimationController, curve: Curves.elasticOut),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewCompletedComplaints()),
              );
            },
            child: _buildBoxWithCircle('Completed Complaints', completedComplaints),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxWithCircle(String title, int count, {bool isPending = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(135, 245, 245, 245),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: isPending ? ColorPicker.yellowColor : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: ColorPicker.blueColor, width: 3),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Text(
                count.toString(),
                key: ValueKey<int>(count),
                style: const TextStyle(color: ColorPicker.blueColor, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWideBox(String title, int count) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(135, 245, 245, 245),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: ColorPicker.blueColor, width: 3),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Text(
                count.toString(),
                key: ValueKey<int>(count),
                style: const TextStyle(color: ColorPicker.blueColor, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(heading, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );
  }

  Widget _buildPendingCard(Map<String, dynamic> complaint) {
    String? beforeImage = complaint['beforeImage'];
    bool hasBeforeImage = beforeImage != null && beforeImage.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Complaint Number:', complaint['complaintNumber'].toString()),
          _buildDetailRow('Name:', complaint['name']),
          _buildDetailRow('Date:', complaint['date']),
          _buildDetailRow('Complaint Type:', complaint['complaintType']),
          _buildDetailRow(
            'Preferred Time:',
            complaint['timePlumbingElectrical']?.isNotEmpty == true
                ? complaint['timePlumbingElectrical']
                : complaint['timeCarpentryCivil'] ?? 'N/A',
          ),
          if (hasBeforeImage) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '$baseUrl${complaint['beforeImage']}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text('📷 Image not available', style: TextStyle(color: Colors.grey)),
                  );
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!hasBeforeImage) {
                    final otpVerified = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AfterPhotoScreen(complaintId: complaint['id'], process: 'before')),
                    );
                    await fetchComplaints();
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AfterPhotoScreen(complaintId: complaint['id'], process: 'after'),
                    ),
                  ).then((_) => fetchComplaints());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPicker.blueColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  hasBeforeImage ? 'End Process' : 'Start Process',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewComplaintDetails(
                        complaint: model.Complaint.fromJson(complaint),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPicker.yellowColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


