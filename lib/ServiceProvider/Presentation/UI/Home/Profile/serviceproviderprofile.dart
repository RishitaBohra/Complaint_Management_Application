// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/serviceproviderlogin.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Profile/serviceprovidereditprofile.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/api_service_baseurl.dart';

// class ServiceProviderProfileScreen extends StatefulWidget {
//   const ServiceProviderProfileScreen({super.key});

//   @override
//   State<ServiceProviderProfileScreen> createState() =>
//       _ServiceProviderProfileScreenState();
// }

// class _ServiceProviderProfileScreenState
//     extends State<ServiceProviderProfileScreen> {
//   Map<String, dynamic>? profileData;
//   bool isLoading = true;
//   int? staffId;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     fetchIdAndProfile();
//   }

//   Future<void> fetchIdAndProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     staffId = prefs.getInt('staffId');
//     token = prefs.getString('token');

//     if (staffId == null || token == null) {
//       debugPrint("❌ No staffId or token found.");
//       setState(() => isLoading = false);
//       return;
//     }

//     debugPrint("📦 staffId: $staffId");
//     debugPrint("📦 Token: $token");

//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     final String profileApi = "${baseUrl}api/front/profile-staff/$staffId";

//     try {
//       final response = await http.get(
//         Uri.parse(profileApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       debugPrint("📦 Service Profile API Response: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         setState(() {
//           profileData = jsonResponse['data'];
//           isLoading = false;
//         });
//       } else {
//         debugPrint("❌ Failed to fetch service profile: ${response.body}");
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching service profile: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> logout() async {
//     bool confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to logout?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );

//     if (confirm) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       if (!mounted) return;
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const ServiceProviderLoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Profile", style: TextStyle(color: Colors.white)),
//         backgroundColor: ColorPicker.blueColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: logout,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : profileData == null
//               ? const Center(child: Text("Failed to load profile"))
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: profileData!['image'] != null
//                             ? NetworkImage("${baseUrl}api/uploads/${profileData!['image']}")
//                             : const AssetImage('assets/logo.png') as ImageProvider,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         profileData!['name'] ?? "No Name",
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Text(
//                       //   "PIN: ${profileData!['pin'] ?? "N/A"}",
//                       //   textAlign: TextAlign.center,
//                       //   style: const TextStyle(
//                       //     fontSize: 16,
//                       //     color: Colors.grey,
//                       //   ),
//                       // ),
//                       const Divider(height: 40),
//                       _buildItem(Icons.phone, "Contact",
//                           profileData!['contact'] ?? "N/A"),
//                       _buildItem(Icons.badge, "Status",
//                           profileData!['status'] ?? "N/A"),
//                       _buildItem(Icons.calendar_today, "Registered On",
//                           profileData!['registrationDate'] ?? "N/A"),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorPicker.blueColor,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const ServiceProviderEditProfileScreen()),
//                           ).then((value) {
//                             if (value == true) {
//                               fetchProfile(); // Refresh after editing
//                             }
//                           });
//                         },
//                         child: const Text("Edit Profile",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildItem(IconData icon, String title, String value) {
//     return ListTile(
//       leading: Icon(icon, color: ColorPicker.blueColor),
//       title: Text(title),
//       subtitle: Text(value),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/serviceproviderlogin.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Profile/serviceprovidereditprofile.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart';

class ServiceProviderProfileScreen extends StatefulWidget {
  const ServiceProviderProfileScreen({super.key});

  @override
  State<ServiceProviderProfileScreen> createState() =>
      _ServiceProviderProfileScreenState();
}

class _ServiceProviderProfileScreenState
    extends State<ServiceProviderProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  int? staffId;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchIdAndProfile();
  }

  Future<void> fetchIdAndProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    staffId = prefs.getInt('staffId');
    token = prefs.getString('token');

    if (staffId == null || token == null) {
      debugPrint("❌ No staffId or token found.");
      setState(() => isLoading = false);
      return;
    }

    debugPrint("📦 staffId: $staffId");
    debugPrint("📦 Token: $token");

    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final String profileApi = "${baseUrl}api/front/profile-staff/$staffId";

    try {
      final response = await http.get(
        Uri.parse(profileApi),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📦 Service Profile API Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            profileData = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          debugPrint("❌ API error: ${jsonResponse['message']}");
          setState(() => isLoading = false);
        }
      } else {
        debugPrint("❌ Failed to fetch profile: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ServiceProviderLoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorPicker.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileData == null
              ? const Center(child: Text("Failed to load profile"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profileData!['image'] != null
                            ? NetworkImage("${baseUrl}${profileData!['image']}")
                            : const AssetImage('assets/logo.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileData!['name'] ?? "No Name",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildItem(Icons.phone, "Contact",
                          profileData!['contact'] ?? "N/A"),
                      _buildItem(Icons.info, "Status",
                          profileData!['status'] ?? "N/A"),
                      _buildItem(Icons.calendar_today, "Registration Date",
                          profileData!['registrationDate'] ?? "N/A"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPicker.blueColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ServiceProviderEditProfileScreen()),
                          ).then((value) {
                            if (value == true) {
                              fetchProfile(); // Refresh after editing
                            }
                          });
                        },
                        child: const Text("Edit Profile",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: ColorPicker.blueColor),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
