// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(ResumeBuilderApp());
// }

// class ResumeBuilderApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI Resume Builder',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ResumeForm(),
//     );
//   }
// }

// class ResumeForm extends StatefulWidget {
//   @override
//   _ResumeFormState createState() => _ResumeFormState();
// }

// class _ResumeFormState extends State<ResumeForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for form input fields
//   final jobTitleController = TextEditingController();
//   final skillsController = TextEditingController();
//   final experienceController = TextEditingController();

//   // State variables for loading and data
//   String? resumeContent;
//   String? pinataUrl;
//   bool isGenerating = false;
//   bool isUploading = false;

//   // Generate Resume Function
//   Future<void> generateResume() async {
//     // Validate the form
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isGenerating = true);

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.10:8000/generate-resume'),  // Replace with your backend URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'jobTitle': jobTitleController.text,
//           'skills': skillsController.text.split(','),
//           'experience': experienceController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           resumeContent = jsonDecode(response.body)['resumeContent'];
//           isGenerating = false;
//         });
//       } else {
//         showError('Failed to generate resume.');
//       }
//     } catch (e) {
//       showError('Error: $e');
//     } finally {
//       setState(() => isGenerating = false);
//     }
//   }

//   // Upload Resume Function
//   Future<void> uploadResume() async {
//     if (resumeContent == null) return;

//     setState(() => isUploading = true);

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.10:8000/upload-resume'),  // Replace with your backend URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'resumeContent': resumeContent,
//           'fileName': 'generated_resume',
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           pinataUrl = data['pinataUrl'];
//           isUploading = false;
//         });
//       } else {
//         showError('Failed to upload resume.');
//       }
//     } catch (e) {
//       showError('Error: $e');
//     } finally {
//       setState(() => isUploading = false);
//     }
//   }

//   // Function to display error messages
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('AI Resume Builder')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Job Title Input
//                 TextFormField(
//                   controller: jobTitleController,
//                   decoration: InputDecoration(labelText: 'Job Title'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a job title';
//                     }
//                     return null;
//                   },
//                 ),

//                 // Skills Input
//                 TextFormField(
//                   controller: skillsController,
//                   decoration: InputDecoration(labelText: 'Skills (comma-separated)'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter at least one skill';
//                     }
//                     return null;
//                   },
//                 ),

//                 // Experience Input
//                 TextFormField(
//                   controller: experienceController,
//                   decoration: InputDecoration(labelText: 'Experience'),
//                   maxLines: 4,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your experience';
//                     }
//                     return null;
//                   },
//                 ),

//                 SizedBox(height: 20),

//                 // Generate Resume Button
//                 ElevatedButton(
//                   onPressed: isGenerating ? null : generateResume,
//                   child: isGenerating
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : Text('Generate Resume'),
//                 ),

//                 // Display Generated Resume (if available)
//                 if (resumeContent != null) ...[
//                   Divider(height: 40),
//                   Text('Generated Resume:', style: TextStyle(fontWeight: FontWeight.bold)),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(resumeContent!),
//                   ),
//                   SizedBox(height: 20),

//                   // Upload Resume Button
//                   ElevatedButton(
//                     onPressed: isUploading ? null : uploadResume,
//                     child: isUploading
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text('Upload to Pinata'),
//                   ),
//                 ],

//                 // Display Pinata URL (if available)
//                 if (pinataUrl != null) ...[
//                   Divider(height: 40),
//                   Text('Resume Uploaded!', style: TextStyle(fontWeight: FontWeight.bold)),
//                   GestureDetector(
//                     onTap: () => print('Open URL: $pinataUrl'),  // Replace with navigation logic if needed
//                     child: Text(pinataUrl!, style: TextStyle(color: Colors.blue)),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(ResumeBuilderApp());
}

class ResumeBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Resume Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResumeForm(),
    );
  }
}

class ResumeForm extends StatefulWidget {
  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _formKey = GlobalKey<FormState>();

  final jobTitleController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();

  String? resumeContent;
  String? pinataUrl;
  bool isGenerating = false;
  bool isUploading = false;

  Future<void> generateResume() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isGenerating = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10:8000/generate-resume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jobTitle': jobTitleController.text,
          'skills': skillsController.text.split(','),
          'experience': experienceController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          resumeContent = jsonDecode(response.body)['resumeContent'];
        });
      } else {
        showError('Failed to generate resume.');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isGenerating = false);
    }
  }

  Future<void> uploadResume() async {
    if (resumeContent == null) return;

    setState(() => isUploading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10:8000/upload-resume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resumeContent': resumeContent,
          'fileName': 'generated_resume',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pinataUrl = data['pinataUrl'];
        });
      } else {
        showError('Failed to upload resume.');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isUploading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Resume Builder'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Form Container
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resume Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Job Title Input
                        TextFormField(
                          controller: jobTitleController,
                          decoration: InputDecoration(
                            labelText: 'Job Title',
                            prefixIcon: Icon(Icons.work),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a job title'
                              : null,
                        ),

                        SizedBox(height: 20),

                        // Skills Input
                        TextFormField(
                          controller: skillsController,
                          decoration: InputDecoration(
                            labelText: 'Skills (comma-separated)',
                            prefixIcon: Icon(Icons.list),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter at least one skill'
                              : null,
                        ),

                        SizedBox(height: 20),

                        // Experience Input
                        TextFormField(
                          controller: experienceController,
                          decoration: InputDecoration(
                            labelText: 'Experience',
                            prefixIcon: Icon(Icons.history),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your experience'
                              : null,
                        ),

                        SizedBox(height: 30),

                        // Generate Resume Button
                        ElevatedButton.icon(
                          onPressed: isGenerating ? null : generateResume,
                          icon: isGenerating
                              ? CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : Icon(Icons.build),
                          label: Text('Generate Resume'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (resumeContent != null) ...[
                SizedBox(height: 30),
                // Display Generated Resume
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated Resume',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(resumeContent!),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: isUploading ? null : uploadResume,
                          icon: isUploading
                              ? CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : Icon(Icons.cloud_upload),
                          label: Text('Upload to Pinata'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (pinataUrl != null) ...[
                SizedBox(height: 30),
                // Display Pinata URL
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resume Uploaded!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Open the URL in the browser
                            print('Open URL: $pinataUrl');
                          },
                          child: Text(
                            pinataUrl!,
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
