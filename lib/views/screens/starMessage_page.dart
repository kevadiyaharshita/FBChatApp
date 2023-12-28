import 'package:chatapp_2/helper/firestore_helper.dart';
import 'package:chatapp_2/modals/user_modal.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../controller/theme_controller.dart';
import '../../utils/color_utils.dart';
import 'chat_page.dart';
import 'components/date_methods.dart';

class StarMessagePage extends StatelessWidget {
  StarMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeTheme,
        foregroundColor: Colors.white,
        title: const Text(
          "Starred Message",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: orangeTheme,
      body: Container(
        height: s.height,
        width: s.width,
        margin: const EdgeInsetsDirectional.only(top: 20),
        decoration: BoxDecoration(
          color:
              themeController.getTheme ? const Color(0xff1C1B1F) : whiteTheme,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(30),
            topEnd: Radius.circular(30),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 1, bottom: 16, right: 16, left: 16),
          child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .getStarMessage(senderEmail: CurrentUser.user.email),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot<Map<String, dynamic>>? data = snapshot.data!;
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    data.docs;

                return (docs.length > 0)
                    ? ListView.separated(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FireStoreHelper.fireStoreHelper
                                .getUserById(email: docs[index]['email']),
                            builder: (context, snapshot2) {
                              if (snapshot2.hasData) {
                                DocumentSnapshot? snap = snapshot2.data;
                                UserModal userModal = UserModal.fromMap(
                                    data: snap!.data() as Map<String, dynamic>);
                                return ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(userModal.profilePic),
                                  ),
                                  title: (userModal.userName ==
                                          CurrentUser.user.userName)
                                      ? const Text(
                                          "You",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          userModal.userName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Card(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                              bottomStart: Radius.circular(0),
                                              topEnd: Radius.circular(15),
                                              topStart: Radius.circular(15),
                                              bottomEnd: Radius.circular(15),
                                            ),
                                          ),
                                          color: docs[index]['type'] == "sent"
                                              ? orangeTheme
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(docs[index]['msg'],
                                                    maxLines: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: docs[index]
                                                                  ['type'] ==
                                                              'sent'
                                                          ? Colors.white
                                                          : null,
                                                    )),
                                                const Gap(8),
                                                Column(
                                                  children: [
                                                    const Gap(8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: docs[index][
                                                                      'type'] ==
                                                                  'sent'
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.7),
                                                          size: 15,
                                                        ),
                                                        getTimeData(
                                                            time: docs[index]
                                                                ['time'],
                                                            type: docs[index]
                                                                ['type']),
                                                        const Gap(3),
                                                        (docs[index]['type'] ==
                                                                'sent')
                                                            ? Icon(
                                                                Icons.done_all,
                                                                size: 20,
                                                                color: (docs[index]
                                                                            [
                                                                            'status'] ==
                                                                        'seen')
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.4),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Gap(60),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Text("No Starred Message..!");
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/Empty-bro.png',
                              scale: 8,
                            ),
                            Text(
                              "No Starred Messages..!!",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: orangeTheme,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Gap(100),
                          ],
                        ),
                      );
              } else {
                return const Text("No Starred Message..!");
              }
            },
          ),
        ),
      ),
    );
  }
}
