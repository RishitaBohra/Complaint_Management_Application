



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/UI/Auth%20File/LoginScreen.dart';
// import 'package:amity_university/User/Presentation/UI/Home/EditProfile.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Map<String, dynamic>? profileData;
//   bool isLoading = true;
//   int? userId;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndProfile();
//   }

//   Future<void> fetchUserIdAndProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getInt('userId');
//     token = prefs.getString('token');

//     if (userId == null || token == null) {
//       debugPrint("❌ No userId or token found.");
//       setState(() => isLoading = false);
//       return;
//     }

//     debugPrint("📦 UserID: $userId");
//     debugPrint("📦 Token: $token");

//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     final String profileApi = "http://192.168.0.7:3000/api/front/profile/?id=$userId";

//     try {
//       final response = await http.get(
//         Uri.parse(profileApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       debugPrint("📦 Profile API Response: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           profileData = data;
//           isLoading = false;
//         });
//       } else {
//         debugPrint("❌ Failed to fetch profile: ${response.body}");
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching profile: $e");
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
//         MaterialPageRoute(builder: (_) => const Loginscreen()),
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
//                             ? NetworkImage("http://192.168.0.7:3000/uploads/${profileData!['image']}")
//                             : const AssetImage('assets/logo.png') as ImageProvider,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         profileData!['name'] ?? "No Name",
//                         style: const TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(profileData!['email'] ?? "No Email"),
//                       const Divider(height: 40),
//                       _buildItem(Icons.phone, "Phone",
//                           profileData!['mobile'] ?? "N/A"),
//                       _buildItem(Icons.home, "Address",
//                           profileData!['address'] ?? "N/A"),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorPicker.blueColor,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const EditProfileScreen()),
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
import 'package:amity_university/api_service_baseurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/UI/Auth%20File/LoginScreen.dart';
import 'package:amity_university/User/Presentation/UI/Home/Profile/EditProfile.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  int? userId;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchUserIdAndProfile();
  }

  Future<void> fetchUserIdAndProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    token = prefs.getString('token');

    if (userId == null || token == null) {
      debugPrint("❌ No userId or token found.");
      setState(() => isLoading = false);
      return;
    }

    debugPrint("📦 UserID: $userId");
    debugPrint("📦 Token: $token");

    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final String profileApi = "${baseUrl}api/front/profile/?id=$userId";

    try {
      final response = await http.get(
        Uri.parse(profileApi),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📦 Profile API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profileData = data;
          isLoading = false;
        });
      } else {
        debugPrint("❌ Failed to fetch profile: ${response.body}");
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
        MaterialPageRoute(builder: (_) => const Loginscreen()),
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
                        radius: 50,
                        backgroundImage: profileData!['image'] != null
                            ? NetworkImage("${baseUrl}uploads/${profileData!['image']}")
                            : const AssetImage('assets/logo.png') as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileData!['name'] ?? "No Name",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profileData!['email'] ?? "No Email",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(height: 40),
                      _buildItem(Icons.phone, "Phone",
                          profileData!['mobile'] ?? "N/A"),
                      _buildItem(Icons.home, "Address",
                          profileData!['address'] ?? "N/A"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPicker.blueColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfileScreen ()),
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
