import 'dart:io';
import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/helper/firestore_helper.dart';
import 'package:chatapp_2/utils/color_utils.dart';
import 'package:chatapp_2/utils/route_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../modals/user_modal.dart';
import '../../utils/current_user_modal.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});

  TextEditingController userNameController = TextEditingController(
      text: CurrentUser.user.userName == 'NULL'
          ? 'UserName'
          : CurrentUser.user.userName);
  String imageUrl = CurrentUser.user.profilePic ==
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'
      ? ''
      : CurrentUser.user.profilePic;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString imagePath = "".obs;
  File? image;

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    User? user = AuthHelper.authHelper.firebaseAuth.currentUser;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Form(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Gap(35),
                              Text(
                                "Update Profile",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: orangeTheme,
                                ),
                              ),
                              const Gap(30),
                              (imageUrl == '')
                                  ? Obx(
                                      () => Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          image: (imageUrl == '')
                                              ? (imagePath != "")
                                                  ? DecorationImage(
                                                      image: FileImage(File(
                                                          imagePath.value)),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null
                                              : DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          color: whiteTheme,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              offset: Offset(2, 2),
                                            )
                                          ],
                                        ),
                                        child: (imageUrl == '')
                                            ? (imagePath.value == "")
                                                ? Icon(
                                                    CupertinoIcons.person_solid,
                                                    color: orangeTheme,
                                                    size: 180,
                                                  )
                                                : null
                                            : null,
                                      ),
                                    )
                                  : Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                        color: whiteTheme,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            offset: Offset(2, 2),
                                          )
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  ImagePicker picker = ImagePicker();
                                  XFile? file;
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Pick Image"),
                                      content: Text(
                                          "Choose the sourse for your image"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            file = await picker.pickImage(
                                                source: ImageSource.camera);
                                            if (file != null) {
                                              image = File(file!.path);
                                              imagePath(file!.path);
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Camera",
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            FirebaseStorage _storage =
                                                FirebaseStorage.instance;
                                            file = await picker.pickImage(
                                                source: ImageSource.gallery);
                                            if (file != null) {
                                              image = File(file!.path);
                                              imagePath(file!.path);
                                              String path =
                                                  'profileimages/${file!.name}';

                                              Reference ref = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child(path);
                                              UploadTask uploadTask =
                                                  ref.putFile(image!);

                                              TaskSnapshot snasps =
                                                  await uploadTask!
                                                      .whenComplete(() {});

                                              String urlDoenload = await snasps
                                                  .ref
                                                  .getDownloadURL();
                                              Logger loggger = Logger();

                                              imageUrl = urlDoenload;

                                              loggger.i("Image : $imageUrl");
                                            }

                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Gallary"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                label: Text(
                                  "Add Photo",
                                  style: TextStyle(
                                      color: orangeTheme, fontSize: 18),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "UserName",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: orangeTheme,
                                      ),
                                    ),
                                    fillColor: greyTheme,
                                  ),
                                  validator: (val) {
                                    return (val == "")
                                        ? "Enter UserName"
                                        : null;
                                  },
                                ),
                              ),
                              const Gap(40),
                              Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: orangeTheme,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    if (userNameController.text != "") {
                                      Logger logger = Logger();
                                      // logger.e("Image url : ${imageUrl}");
                                      await FireStoreHelper.fireStoreHelper
                                          .updateProfile(
                                              userName: userNameController.text,
                                              imageUrl: imageUrl)
                                          .then((value) async {
                                        UserModal userModal =
                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .getUserByEmail(
                                                    email:
                                                        user!.email as String);
                                        CurrentUser.user = userModal;
                                        // print("Profile Updated...");
                                        return Navigator.of(context)
                                            .pushReplacementNamed(
                                                MyRoutes.home);
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  splashColor: Colors.orangeAccent,
                                  child: Container(
                                    height: 50,
                                    width: s.width,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Update Profile",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(280),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 230,
                      width: s.width,
                      decoration: BoxDecoration(
                        color: orangeTheme,
                        boxShadow: [
                          BoxShadow(
                              color: greyTheme.withOpacity(0.5),
                              blurRadius: 10),
                          BoxShadow(color: orangeTheme, blurRadius: 10),
                        ],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(200),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/NewLogo.png',
                            scale: 2.5,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
