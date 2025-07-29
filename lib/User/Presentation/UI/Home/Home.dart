

//with animations

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amity_university/User/Presentation/model/complaint_model.dart';
import 'package:amity_university/User/Presentation/UI/Home/ComplaintForm.dart';
import 'package:amity_university/User/Presentation/UI/Home/Viewdetails.dart';
import 'package:amity_university/User/Presentation/UI/Home/view_complaints.dart';
import 'package:amity_university/User/Presentation/UI/Home/Notifications.dart';
import 'package:amity_university/User/Presentation/UI/Home/plan.dart';
import 'package:amity_university/User/Presentation/UI/Home/Profile/profile.dart';
import 'package:amity_university/User/Presentation/UI/Home/ratingscreen.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Complaint> recentComplaints = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _bannerTimer;
  Timer? _autoRefreshTimer;

  List<String> images = ['assets/logo.png', 'assets/logo.png', 'assets/logo.png'];

  String? userName;
  String? userImage;
  int? userId;

  bool _dataLoaded = false;
  bool _isLoading = true;

  late AnimationController gridAnimationController;
  late AnimationController complaintAnimationController;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
    startAutoRefresh();
    loadUserProfileAndData();

    gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    complaintAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    gridAnimationController.forward();
    complaintAnimationController.forward();
  }

  void startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients && mounted) {
        int nextPage = (_currentIndex + 1) % images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextPage;
        });
      }
    });
  }

  void startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (_dataLoaded && mounted) {
        fetchComplaints();
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _autoRefreshTimer?.cancel();
    _pageController.dispose();
    gridAnimationController.dispose();
    complaintAnimationController.dispose();
    super.dispose();
  }

  Future<void> loadUserProfileAndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    userName = prefs.getString('userName') ?? 'Welcome';
    userImage = prefs.getString('userImage');

    await Future.wait([
      fetchComplaints(),
      // fetchBannerImages(),
    ]);

    if (mounted) {
      setState(() {
        _dataLoaded = true;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchComplaints() async {
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse("${baseUrl}api/complaints/userComplaint/$userId"),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] as List;
        List<Complaint> userComplaints = data.map((e) => Complaint.fromJson(e)).toList();

        userComplaints.sort((a, b) {
          DateTime aDate = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
          DateTime bDate = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });

        if (mounted) {
          setState(() {
            recentComplaints = userComplaints.take(3).toList();
          });
        }
      } else {
        debugPrint("❌ API failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching complaints: $e");
    }
  }

  // Future<void> fetchBannerImages() async {
  //   try {
  //     final response = await http.get(Uri.parse("${baseUrl}api/admin/banner"));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);

  //       List<String> loadedImages = [];

  //       for (var item in data) {
  //         if (item is Map && item.containsKey('image')) {
  //           String? imageName = item['image'];
  //           if (imageName != null && imageName.isNotEmpty) {
  //             loadedImages.add("${baseUrl}uploads/banners/$imageName");
  //           }
  //         }
  //       }

  //       if (loadedImages.isEmpty) {
  //         loadedImages = ['assets/logo.png'];
  //       }

  //       if (mounted) {
  //         setState(() {
  //           images = loadedImages.length == 1
  //               ? List.filled(3, loadedImages[0])
  //               : loadedImages;
  //         });
  //       }
  //     } else {
  //       debugPrint("❌ Banner API failed: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Error fetching banners: $e");
  //   }
  // }

  Future<void> manualRefresh() async {
    await fetchComplaints();
  }

  Widget buildBannerSection() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.isNotEmpty ? images.length : 1,
            onPageChanged: (index) {
              if (images.isNotEmpty) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            itemBuilder: (context, index) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: ClipRRect(
                  key: ValueKey(images[index]),
                  borderRadius: BorderRadius.circular(12),
                  child: bannerImage(images[index]),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.isNotEmpty ? images.length : 1,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                width: _currentIndex == index ? 10 : 6,
                height: _currentIndex == index ? 10 : 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? ColorPicker.blueColor
                      : Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bannerImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/logo.png', fit: BoxFit.cover);
        },
      );
    } else {
      return Image.asset(url, fit: BoxFit.cover, width: double.infinity);
    }
  }

  Widget buildGridMenu() {
    return ScaleTransition(
      scale: CurvedAnimation(parent: gridAnimationController, curve: Curves.easeInOut),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: [
          _buildGridTile(Icons.folder, 'Add Complaint', ComplaintFormPage()),
          _buildGridTile(Icons.remove_red_eye_outlined, 'View Complaint', ViewComplaints()),
        ],
      ),
    );
  }

  Widget _buildGridTile(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        fetchComplaints();
      },
      child: Card(
        color: ColorPicker.blueColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecentComplaintsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRecentComplaintsHeader(),
        const SizedBox(height: 10),
        if (recentComplaints.isEmpty)
          const Center(child: Text("No recent complaints", style: TextStyle(color: Colors.grey)))
        else
          ListView.builder(
            itemCount: recentComplaints.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final complaint = recentComplaints[index];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: complaintAnimationController,
                    curve: Interval(0.1 * index, 0.6, curve: Curves.easeOut),
                  ),
                ),
                child: _buildComplaintCard(complaint),
              );
            },
          ),
      ],
    );
  }

  Widget _buildRecentComplaintsHeader() {
    return Row(
      children: [
        const Text("Recent Complaints", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewComplaints())),
          child: const Text("View All",
              style: TextStyle(color: ColorPicker.blueColor, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorPicker.yellowColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Complaint",
                      style: TextStyle(fontSize: 12, color: ColorPicker.blueColor),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: ColorPicker.blueColor),
                      const SizedBox(width: 5),
                      Text(complaint.date, style: const TextStyle(color: ColorPicker.blueColor)),
                    ],
                  ),
                ],
              ),
              const Divider(),
              _buildRow(Icons.person, "Complainant Name:", complaint.name),
              _buildRow(Icons.report_problem, "Type:", complaint.complaintType),
              _buildRow(Icons.location_on, "Location:", complaint.block),
              _buildRow(Icons.info_outline, "Status:", complaint.status),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (complaint.status.toLowerCase() == "completed")
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RatingScreen()),
                          );
                        },
                        child: const Text("Rate Us", style: TextStyle(color: Colors.green)),
                      ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ViewDetails(complaint: complaint)),
                        );
                        fetchComplaints();
                      },
                      child: const Text("View Details", style: TextStyle(color: ColorPicker.blueColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorPicker.blueColor,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
                  child: CircleAvatar(
                    backgroundImage: userImage != null && userImage!.startsWith('http')
                        ? NetworkImage(userImage!)
                        : const AssetImage('assets/logo.png') as ImageProvider,
                    radius: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  userName ?? 'Welcome',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen())),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: manualRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    buildBannerSection(),
                    const SizedBox(height: 10),
                    buildGridMenu(),
                    const SizedBox(height: 20),
                    buildRecentComplaintsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
