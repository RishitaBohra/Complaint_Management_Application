
// import 'dart:convert';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
// import 'package:amity_university/api_service_baseurl.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/UI/Home/Home.dart'; 

// class RatingScreen extends StatefulWidget {
//   const RatingScreen({super.key});

//   @override
//   State<RatingScreen> createState() => _RatingScreenState();
// }

// class _RatingScreenState extends State<RatingScreen> {
//   int _selectedRating = 4; // Default rating
//   bool _isSubmitting = false;

//   Future<void> _submitRating() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('userId'); // Get userId from SharedPreferences
//     String? userName = prefs.getString('userName'); // Get userName from SharedPreferences
//     int? staffId = prefs.getInt('staffId'); // Staff being rated
//     String? staffName = prefs.getString('staffName'); // Staff Name

//     if (userId == null || userName == null || staffId == null || staffName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User or Staff info missing.')),
//       );
//       return;
//     }

//     setState(() {
//       _isSubmitting = true;
//     });

//     final url = Uri.parse('$baseUrl/front/rating/');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "staffId": staffId,
//         "staffName": staffName,
//         "userId": userId,
//         "userName": userName,
//         "rating": _selectedRating,
//         "comment": "Very helpful and polite." // Optional static comment
//       }),
//     );

//     setState(() {
//       _isSubmitting = false;
//     });

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Thanks for your feedback!')),
//       );
//       Navigator.pop(context); // Go back after success
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit rating. Error: ${response.statusCode}')),
//       );
//     }
//   }

//   Widget _buildStar(int index) {
//     return IconButton(
//       onPressed: () {
//         setState(() {
//           _selectedRating = index;
//         });
//       },
//       icon: Icon(
//         Icons.star,
//         size: 40,
//         color: index <= _selectedRating ? Colors.amber : Colors.grey,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 24),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue),
//             borderRadius: BorderRadius.circular(12),
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.yellow.shade100,
//                 child: const Text(
//                   "⭐",
//                   style: TextStyle(fontSize: 30),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 "Please let us know how we did!\nRate our service.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) => _buildStar(index + 1)),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorPicker.blueColor,
//                   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: _isSubmitting ? null : _submitRating,
//                 child: _isSubmitting
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Rate us", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()),
//                     (route) => false,
//                   );
//                 },
//                 child: const Text(
//                   "No, Thanks!",
//                   style: TextStyle(color: Colors.black87),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/api_service_baseurl.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _selectedRating = 4; 
  bool _isSubmitting = false;

  Future<void> _submitRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId'); 
    String? userName = prefs.getString('userName'); 
    int? staffId = prefs.getInt('staffId'); 
    String? staffName = prefs.getString('staffName'); 

    if (userId == null || userName == null || staffId == null || staffName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User or Staff info missing.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('${baseUrl}api/front/rating');
    final payload = {
      "staffId": staffId,
      "staffName": staffName,
      "userId": userId,
      "userName": userName,
      "rating": _selectedRating,
      "comment": "Very helpful and polite." 
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'] ?? 'Rating submitted successfully')),
          );
          Navigator.pop(context); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'] ?? 'Something went wrong.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          _selectedRating = index;
        });
      },
      icon: Icon(
        Icons.star,
        size: 40,
        color: index <= _selectedRating ? Colors.amber : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.yellow.shade100,
                child: const Text(
                  "⭐",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Please let us know how we did!\nRate our service.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => _buildStar(index + 1)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPicker.blueColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isSubmitting ? null : _submitRating,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Rate us", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "No, Thanks!",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
