import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testfirebase/data/firebase_service/firestor.dart';
import 'package:testfirebase/data/model/usermodel.dart';

import '../chat/data/models/user_model.dart';
import '../theme/theme_provider.dart';
import '../util/imagepicker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  bool isLoading = false;
  String? _currentImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("المستخدم غير مسجل الدخول");
      }

      Usermodel userData = await Firebase_Firestor().getUser(UID: userId);

      setState(() {
        usernameController.text = userData.username;
        bioController.text = userData.bio;
        emailController.text = userData.email;
        _currentImage = userData.profile;
      });
    } catch (e) {
      print("خطأ في جلب البيانات: $e");
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true;
    });

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    String? imageUrl = _currentImage;
    if (_imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profileImages')
          .child('$userId.jpg');
      await ref.putFile(_imageFile!);
      imageUrl = await ref.getDownloadURL();
    }

    await Firebase_Firestor().CreateUser(
      // uid: userId,
      username: usernameController.text,
      bio: bioController.text,
      email: emailController.text,
      profile: imageUrl ?? '',
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Back",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _updateProfile();
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // صورة الملف الشخصي
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        File imageFile =
                        await ImagePickerr().uploadImage('camera');
                        setState(() {
                          _imageFile = imageFile;
                        });
                      },
                      child: CircleAvatar(
                        radius: 50.w,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        backgroundImage: _imageFile == null
                            ? (_currentImage != null
                            ? NetworkImage(_currentImage!)
                            : const AssetImage('images/person.png'))
                        as ImageProvider
                            : FileImage(_imageFile!),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextButton(
                      onPressed: () async {
                        File imageFile =
                        await ImagePickerr().uploadImage('camera');
                        setState(() {
                          _imageFile = imageFile;
                        });
                      },
                      child: const Text(
                        'Change Profile Photo',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // الحقول
              buildTextField("Name", nameController, ),
              buildTextField("Username", usernameController),
              buildTextField("Website", websiteController,
                 ),
              buildTextField("Bio", bioController, ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Switch to Professional Account",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Private Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              buildTextField("Email", emailController, ),
              buildTextField("Phone", phoneController, ),
              buildTextField("Gender", genderController, ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller,
     ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14.sp,
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(color:Theme.of(context).colorScheme.secondary),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color:Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}