//SACHIN SIR'S CODE

// import 'dart:convert';
// import 'dart:io';

// import 'package:amity_university/api_service_baseurl.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AfterPhotoScreen extends StatefulWidget {
//   final int complaintId;
//   final String process;//"before","after"
//   const AfterPhotoScreen({super.key, required this.complaintId,required this.process});

//   @override
//   State createState() => _AfterPhotoScreenState();
// }

// class _AfterPhotoScreenState extends State<AfterPhotoScreen> {
//   File? _imageFile;

//   String? _imageUrl;

//   final picker = ImagePicker();
//   bool _isUploading = false;
//   String? errorMessage;
//   final TextEditingController _remarksController = TextEditingController();

//   Future _openCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//       _imageUrl = await uploadFileToServer(_imageFile!);
//       errorMessage = null;
//       setState(()  {

//       });
//     } else {
//       debugPrint('📸 No image selected.');
//     }
//   }



//   Future<String?> uploadFileToServer(File file) async {
//     final uri = Uri.parse('${baseUrl}api/complaints/endProcess');
//     final request = http.MultipartRequest('POST', uri,);

//     // Attach file

//     request.files.add(await http.MultipartFile.fromPath('file', file.path));

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = response.body;
//         final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(data)?.group(1);
//         return url != null ? url : null;
//       } else {
//         print('Upload failed: ${response.statusCode} ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during file upload: $e');
//       return null;
//     }
//   }

//   Future _uploadPhoto() async {
//     if (_imageFile == null||_imageUrl==null) {
//       print('image url null $_imageUrl');
//       //Get.showToast('Please capture an after photo first.');
//       // AwesomeToster().showOverlay(
//       //   context: context,
//       //   msg: 'Please capture an after photo first.',
//       //   tosterHeight: 50,
//       //   msgType: MsgType.WARNING,
//       // );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       errorMessage = null;
//     });

//     print('📤 Uploading after photo: $_imageUrl');

//     Map<String,dynamic> data = {};
//     if(widget.process=='before'){
//     //   "beforeImage": _imageUrl1,
//     // "afterImage": _imageUrl2,
//       data['beforeImage'] = _imageUrl;
//     }else{
//       data['afterImage'] = _imageUrl;
//     }

//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('${baseUrl}api/complaints/endProcess/47'),
//       );
//       request.body = json.encode(data);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//       } else {
//         print(response.reasonPhrase);
//       }
//     } catch (e) {
//       debugPrint('❌ Upload error: $e');
//       setState(() {
//         errorMessage = 'Upload failed: $e';
//       });
//       // AwesomeToster().showOverlay(
//       //   context: context,
//       //   msg: 'Upload failed: $e',
//       //   tosterHeight: 50,
//       //   msgType: MsgType.ERROR,
//       // );
//      // Get.showToast('Upload failed: $e');
//     }

//     setState(() {
//       _isUploading = false;
//     });
//   }

//   Future _handleResponse(http.StreamedResponse response) async {
//     String responseBody = await response.stream.bytesToString();
//     debugPrint('📥 Server response: $responseBody');

//     if (response.statusCode == 200) {
//       debugPrint('✅ Upload success');
//       // AwesomeToster().showOverlay(
//       //   context: context,
//       //   msg: 'After photo uploaded successfully!',
//       //   tosterHeight: 50,
//       //   msgType: MsgType.SUCESS,
//       // );
//      // Get.showToast('After photo uploaded successfully!');
//       // if (context.mounted) {
//       //   Navigator.of(context).pushAndRemoveUntil(
//       //     MaterialPageRoute(
//       //       builder: (context) => const ServiceProviderHomeScreen(),
//       //     ),
//       //         (route) => false,
//       //   );
//       // }
//     } else {
//       debugPrint(
//           '⚠️ Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
//       setState(() {
//         errorMessage = 'Upload failed: ${response.reasonPhrase}';
//       });
//       // AwesomeToster().showOverlay(
//       //   context: context,
//       //   msg: 'Upload failed: ${response.reasonPhrase}',
//       //   tosterHeight: 50,
//       //   msgType: MsgType.ERROR,
//       // );
//       //Get.showToast('Upload failed: ${response.reasonPhrase}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text(
//           "Upload After Photo",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child:
//           // _imageFile == null
//           //     ? SingleChildScrollView(
//           //   child: Column(
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: [
//           //       const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
//           //       const SizedBox(height: 20),
//           //       ElevatedButton(
//           //         style: ElevatedButton.styleFrom(
//           //           backgroundColor: Colors.red,//ColorPicker.blueColor,
//           //         ),
//           //         onPressed: _openCamera,
//           //         child: const Text(
//           //           "Capture After Photo",
//           //           style: TextStyle(color: Colors.white),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // )
//           //     :
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if(_imageFile == null)
//                 Column(
//                   children: [
//                     const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,//ColorPicker.blueColor,
//                       ),
//                       onPressed: _openCamera,
//                       child: const Text(
//                         "Capture After Photo",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 )
//               else
//                 Image.file(_imageFile!, height: 300),


//               // Image.file(_imageFile!, height: 300),
//               // const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextField(
//                   controller: _remarksController,
//                   decoration: const InputDecoration(
//                     labelText: "Remarks (optional)",
//                     border: OutlineInputBorder(),
//                     hintText: "Enter remarks about the complaint resolution",
//                   ),
//                   maxLines: 3,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: _isUploading ? null : _uploadPhoto,
//                     icon: const Icon(Icons.upload, color: Colors.white),
//                     label: _isUploading
//                         ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                         : const Text(
//                       "Submit",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   // ElevatedButton.icon(
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Colors.amber,
//                   //   ),
//                   //   onPressed: _openCamera,
//                   //   icon:
//                   //   const Icon(Icons.camera_alt, color: Colors.black),
//                   //   label: const Text(
//                   //     "Retake",
//                   //     style: TextStyle(color: Colors.black),
//                   //   ),
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Text(
//                       errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//WORKING CODE WITHOUT UI CHANGES 
// import 'dart:convert';
// import 'dart:io';

// import 'package:amity_university/api_service_baseurl.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AfterPhotoScreen extends StatefulWidget {
//   final int complaintId;
//   final String process; // "before","after"
//   const AfterPhotoScreen({super.key, required this.complaintId, required this.process});

//   @override
//   State createState() => _AfterPhotoScreenState();
// }

// class _AfterPhotoScreenState extends State<AfterPhotoScreen> {
//   File? _imageFile;
//   String? _imageUrl;

//   final picker = ImagePicker();
//   bool _isUploading = false;
//   String? errorMessage;
//   final TextEditingController _remarksController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _imageFile = null; // 🔧 Reset image on screen load
//     _imageUrl = null;
//   }

//   Future _openCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//       _imageUrl = await uploadFileToServer(_imageFile!);
//       errorMessage = null;
//       setState(() {});
//     } else {
//       debugPrint('📸 No image selected.');
//     }
//   }

//   Future<String?> uploadFileToServer(File file) async {
//     final uri = Uri.parse('${baseUrl}api/complaints/endProcess');
//     final request = http.MultipartRequest('POST', uri);

//     request.files.add(await http.MultipartFile.fromPath('file', file.path));

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = response.body;
//         final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(data)?.group(1);
//         return url != null ? url : null;
//       } else {
//         print('Upload failed: ${response.statusCode} ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during file upload: $e');
//       return null;
//     }
//   }

//   Future _uploadPhoto() async {
//     if (_imageFile == null || _imageUrl == null) {
//       print('image url null $_imageUrl');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       errorMessage = null;
//     });

//     print('📤 Uploading ${widget.process} photo: $_imageUrl');

//     Map<String, dynamic> data = {};
//     if (widget.process == 'before') {
//       data['beforeImage'] = _imageUrl;
//     } else {
//       data['afterImage'] = _imageUrl;
//     }

//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('${baseUrl}api/complaints/endProcess/${widget.complaintId}'),
//       );
//       request.body = json.encode(data);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());

//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "${widget.process.capitalize()} photo uploaded successfully!",
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context); // Navigate back after upload
//         }
//       } else {
//         print(response.reasonPhrase);
//         setState(() {
//           errorMessage = 'Upload failed: ${response.reasonPhrase}';
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Upload error: $e');
//       setState(() {
//         errorMessage = 'Upload failed: $e';
//       });
//     }

//     setState(() {
//       _isUploading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           widget.process == "before" ? "Upload Before Photo" : "Upload After Photo",
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue.shade700,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   if (_imageFile == null)
//                     Column(
//                       children: [
//                         const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
//                         const SizedBox(height: 20),
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           onPressed: _openCamera,
//                           icon: const Icon(Icons.camera_alt, color: Colors.white),
//                           label: Text(
//                             widget.process == "before" ? "Capture Before Photo" : "Capture After Photo",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(_imageFile!, height: 250, fit: BoxFit.cover),
//                     ),

//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _remarksController,
//                     decoration: InputDecoration(
//                       labelText: "Remarks (optional)",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       hintText: "Enter remarks about the complaint resolution",
//                     ),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: _isUploading ? null : _uploadPhoto,
//                     icon: _isUploading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.upload, color: Colors.white),
//                     label: Text(
//                       _isUploading ? "Uploading..." : "Submit",
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   if (errorMessage != null)
//                     Text(
//                       errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     if (isEmpty) return "";
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }

//WORKING CODE WITH UI CHANGES 
// import 'dart:convert';
// import 'dart:io';

// import 'package:amity_university/api_service_baseurl.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AfterPhotoScreen extends StatefulWidget {
//   final int complaintId;
//   final String process; // "before","after"
//   const AfterPhotoScreen({super.key, required this.complaintId, required this.process});

//   @override
//   State createState() => _AfterPhotoScreenState();
// }

// class _AfterPhotoScreenState extends State<AfterPhotoScreen> {
//   File? _imageFile;
//   String? _imageUrl;

//   final picker = ImagePicker();
//   bool _isUploading = false;
//   String? errorMessage;
//   final TextEditingController _remarksController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _imageFile = null; // 🔧 Reset image on screen load
//     _imageUrl = null;
//   }

//   Future _openCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//       _imageUrl = await uploadFileToServer(_imageFile!);
//       errorMessage = null;
//       setState(() {});
//     } else {
//       debugPrint('📸 No image selected.');
//     }
//   }

//   Future<String?> uploadFileToServer(File file) async {
//     final uri = Uri.parse('${baseUrl}api/complaints/endProcess');
//     final request = http.MultipartRequest('POST', uri);

//     request.files.add(await http.MultipartFile.fromPath('file', file.path));

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = response.body;
//         final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(data)?.group(1);
//         return url != null ? url : null;
//       } else {
//         print('Upload failed: ${response.statusCode} ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during file upload: $e');
//       return null;
//     }
//   }

//   Future _uploadPhoto() async {
//     if (_imageFile == null || _imageUrl == null) {
//       print('image url null $_imageUrl');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       errorMessage = null;
//     });

//     print('📤 Uploading ${widget.process} photo: $_imageUrl');

//     Map<String, dynamic> data = {};
//     if (widget.process == 'before') {
//       data['beforeImage'] = _imageUrl;
//     } else {
//       data['afterImage'] = _imageUrl;
//     }

//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('${baseUrl}api/complaints/endProcess/${widget.complaintId}'),
//       );
//       request.body = json.encode(data);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());

//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "${widget.process.capitalize()} photo uploaded successfully!",
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context); // Navigate back after upload
//         }
//       } else {
//         print(response.reasonPhrase);
//         setState(() {
//           errorMessage = 'Upload failed: ${response.reasonPhrase}';
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Upload error: $e');
//       setState(() {
//         errorMessage = 'Upload failed: $e';
//       });
//     }

//     setState(() {
//       _isUploading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           widget.process == "before" ? "Upload Before Photo" : "Upload After Photo",
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue.shade700,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   if (_imageFile == null)
//                     Column(
//                       children: [
//                         const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
//                         const SizedBox(height: 20),
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           onPressed: _openCamera,
//                           icon: const Icon(Icons.camera_alt, color: Colors.white),
//                           label: Text(
//                             widget.process == "before" ? "Capture Before Photo" : "Capture After Photo",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(_imageFile!, height: 250, fit: BoxFit.cover),
//                     ),

//                   const SizedBox(height: 20),
//                   if (widget.process == "after")
//                     TextField(
//                       controller: _remarksController,
//                       decoration: InputDecoration(
//                         labelText: "Remarks (optional)",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         hintText: "Enter remarks about the complaint resolution",
//                       ),
//                       maxLines: 3,
//                     ),
//                   if (widget.process == "after") const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: _isUploading ? null : _uploadPhoto,
//                     icon: _isUploading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.upload, color: Colors.white),
//                     label: Text(
//                       _isUploading ? "Uploading..." : "Submit",
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   if (errorMessage != null)
//                     Text(
//                       errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     if (isEmpty) return "";
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }










// import 'dart:convert';
// import 'dart:io';

// import 'package:amity_university/ServiceProvider/Presentation/Constants/constant.dart';
// import 'package:amity_university/api_service_baseurl.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AfterPhotoScreen extends StatefulWidget {
//   final int complaintId;
//   final String process; // "before","after"
//   const AfterPhotoScreen({super.key, required this.complaintId, required this.process});

//   @override
//   State createState() => _AfterPhotoScreenState();
// }

// class _AfterPhotoScreenState extends State<AfterPhotoScreen> {
//   File? _imageFile;
//   String? _imageUrl;

//   final picker = ImagePicker();
//   bool _isUploading = false;
//   String? errorMessage;
//   final TextEditingController _remarksController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _imageFile = null; // 🔧 Reset image on screen load
//     _imageUrl = null;
//   }

//   Future _openCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//       _imageUrl = await uploadFileToServer(_imageFile!);
//       errorMessage = null;
//       setState(() {});
//     } else {
//       debugPrint('📸 No image selected.');
//     }
//   }

//   Future<String?> uploadFileToServer(File file) async {
//     final uri = Uri.parse('${baseUrl}api/complaints/endProcess');
//     final request = http.MultipartRequest('POST', uri);

//     request.files.add(await http.MultipartFile.fromPath('file', file.path));

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = response.body;
//         final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(data)?.group(1);
//         return url != null ? url : null;
//       } else {
//         print('Upload failed: ${response.statusCode} ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during file upload: $e');
//       return null;
//     }
//   }

//   Future _uploadPhoto() async {
//     if (_imageFile == null || _imageUrl == null) {
//       print('image url null $_imageUrl');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       errorMessage = null;
//     });

//     print('📤 Uploading ${widget.process} photo: $_imageUrl');

//     Map<String, dynamic> data = {};
//     if (widget.process == 'before') {
//       data['beforeImage'] = _imageUrl;
//     } else {
//       data['afterImage'] = _imageUrl;
//       data['remarks'] = _remarksController.text; // ✅ send remarks only for after
//     }

//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('${baseUrl}api/complaints/endProcess/${widget.complaintId}'),
//       );
//       request.body = json.encode(data);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());

//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "${widget.process.capitalize()} photo uploaded successfully!",
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context); // Navigate back after upload
//         }
//       } else {
//         print(response.reasonPhrase);
//         setState(() {
//           errorMessage = 'Upload failed: ${response.reasonPhrase}';
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Upload error: $e');
//       setState(() {
//         errorMessage = 'Upload failed: $e';
//       });
//     }

//     setState(() {
//       _isUploading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           widget.process == "before" ? "Upload Before Photo" : "Upload After Photo",
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: ColorPicker.blueColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   if (_imageFile == null)
//                     Column(
//                       children: [
//                         const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
//                         const SizedBox(height: 20),
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorPicker.blueColor,
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           onPressed: _openCamera,
//                           icon: const Icon(Icons.camera_alt, color: Colors.white),
//                           label: Text(
//                             widget.process == "before" ? "Capture Before Photo" : "Capture After Photo",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(_imageFile!, height: 250, fit: BoxFit.cover),
//                     ),

//                   const SizedBox(height: 20),

//                   // ✅ Show remarks only for "after" process
//                   if (widget.process == "after")
//                     Column(
//                       children: [
//                         TextField(
//                           controller: _remarksController,
//                           decoration: InputDecoration(
//                             labelText: "Remarks (optional)",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             hintText: "Enter remarks about the complaint resolution",
//                           ),
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),

//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorPicker.blueColor,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: _isUploading ? null : _uploadPhoto,
//                     icon: _isUploading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.upload, color: Colors.white),
//                     label: Text(
//                       _isUploading ? "Uploading..." : "Submit",
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   if (errorMessage != null)
//                     Text(
//                       errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     if (isEmpty) return "";
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }


//Issue resolve: by default back camera opens
//Issue resolve: show loader on upload
import 'dart:convert';
import 'dart:io';

import 'package:amity_university/ServiceProvider/Presentation/Constants/constant.dart';
import 'package:amity_university/api_service_baseurl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:amity_university/main.dart';

class AfterPhotoScreen extends StatefulWidget {
  final int complaintId;
  final String process;
  const AfterPhotoScreen({super.key, required this.complaintId, required this.process});

  @override
  State createState() => _AfterPhotoScreenState();
}

class _AfterPhotoScreenState extends State<AfterPhotoScreen> {
  File? _imageFile;
  String? _imageUrl;

  bool _isUploading = false;
  String? errorMessage;
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _imageUrl = null;
  }

  Future<void> _openCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CameraCaptureScreen()),
    );

    if (result != null && result is File) {
      setState(() {
        _isUploading = true;
      });

      _imageFile = result;
      _imageUrl = await uploadFileToServer(_imageFile!);
      errorMessage = null;

      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String?> uploadFileToServer(File file) async {
    final uri = Uri.parse('${baseUrl}api/complaints/endProcess');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = response.body;
        final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(data)?.group(1);
        return url;
      } else {
        print('Upload failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during file upload: $e');
      return null;
    }
  }

  Future _uploadPhoto() async {
    if (_imageFile == null || _imageUrl == null) {
      print('image url null $_imageUrl');
      return;
    }

    setState(() {
      _isUploading = true;
      errorMessage = null;
    });

    print('📤 Uploading ${widget.process} photo: $_imageUrl');

    Map<String, dynamic> data = {};
    if (widget.process == 'before') {
      data['beforeImage'] = _imageUrl;
    } else {
      data['afterImage'] = _imageUrl;
      data['remarks'] = _remarksController.text;
    }

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('${baseUrl}api/complaints/endProcess/${widget.complaintId}'),
      );
      request.body = json.encode(data);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${widget.process.capitalize()} photo uploaded successfully!",
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        print(response.reasonPhrase);
        setState(() {
          errorMessage = 'Upload failed: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      debugPrint('❌ Upload error: $e');
      setState(() {
        errorMessage = 'Upload failed: $e';
      });
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              widget.process == "before" ? "Upload Before Photo" : "Upload After Photo",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorPicker.blueColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (_imageFile == null)
                        Column(
                          children: [
                            const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPicker.blueColor,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: _openCamera,
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              label: Text(
                                widget.process == "before" ? "Capture Before Photo" : "Capture After Photo",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_imageFile!, height: 250, fit: BoxFit.cover),
                        ),

                      const SizedBox(height: 20),

                      if (widget.process == "after")
                        Column(
                          children: [
                            TextField(
                              controller: _remarksController,
                              decoration: InputDecoration(
                                labelText: "Remarks (optional)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: "Enter remarks about the complaint resolution",
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPicker.blueColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _isUploading ? null : _uploadPhoto,
                        icon: _isUploading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload, color: Colors.white),
                        label: Text(
                          _isUploading ? "Uploading..." : "Submit",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isUploading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// ⬇️ IMPROVED CAMERA SCREEN UI ONLY
class CameraCaptureScreen extends StatefulWidget {
  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.back),
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();
      Navigator.pop(context, File(image.path));
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }
}
