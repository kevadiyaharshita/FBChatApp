import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/helper/firestore_helper.dart';
import 'package:chatapp_2/helper/local_notification%20helper.dart';
import 'package:chatapp_2/modals/user_modal.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:chatapp_2/utils/date_utils.dart';
import 'package:chatapp_2/utils/route_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import '../../controller/theme_controller.dart';
import '../../modals/chat_modal.dart';
import '../../utils/color_utils.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    // User? user = AuthHelper.authHelper.firebaseAuth.currentUser!;
    UserModal user = CurrentUser.user;
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeTheme,
        foregroundColor: Colors.white,
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     LocalNotificationHelper.localNotificationHelper
          //         .sendMediaNotification(title: 'demo', body: 'this is..');
          //   },
          //   icon: Icon(Icons.notification_add),
          // ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.star_message_page);
              },
              icon: Icon(
                Icons.star,
                size: 28,
              )),
          SizedBox(
            width: 5,
          )
        ],
        // elevation: 5,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: orangeTheme),
              accountName: Text(
                user.userName ?? "",
                style: TextStyle(fontSize: 20),
              ),
              accountEmail:
                  Text(user.email as String, style: TextStyle(fontSize: 16)),
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(
                  user.profilePic ??
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyRoutes.update_profile);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: orangeTheme,
                    size: 25,
                  ),
                ),
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: orangeTheme),
                )
              ],
            ),
            Obx(() {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      themeController.changeTheme();
                      themeController.getTheme
                          ? Get.changeTheme(ThemeData.dark(useMaterial3: true))
                          : Get.changeTheme(
                              ThemeData.light(useMaterial3: true));
                    },
                    icon: themeController.getTheme
                        ? Icon(
                            Icons.light_mode_outlined,
                            color: orangeTheme,
                            size: 30,
                          )
                        : Icon(
                            Icons.light_mode_rounded,
                            color: orangeTheme,
                            size: 30,
                          ),
                  ),
                  Text(
                    themeController.getTheme ? "Light Theme" : "Dark Theme",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: orangeTheme),
                  )
                ],
              );
            }),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    AuthHelper.authHelper.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(MyRoutes.sign_in_page);
                  },
                  icon: Icon(Icons.logout, color: orangeTheme, size: 30),
                ),
                Text(
                  "Sign Out",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: orangeTheme),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orangeTheme,
        foregroundColor: Colors.white,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: orangeTheme,
                contentPadding: EdgeInsetsDirectional.all(0),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "Add Friend",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                content: SizedBox(
                  height: 360,
                  width: 360,
                  child: StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.getAllUsersData(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        QuerySnapshot? snap = snapshot2.data;

                        List<QueryDocumentSnapshot> allData = snap!.docs;

                        List<UserModal> allUsers = allData
                            .map((e) => UserModal.fromMap(
                                data: e.data() as Map<String, dynamic>))
                            .toList();

                        allUsers.removeWhere(
                            (element) => element.email == user.email);
                        return Container(
                          height: 360,
                          width: 360,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 3, color: orangeTheme),
                            color: themeController.getTheme
                                ? const Color(0xff1C1B1F)
                                : Colors.white,
                          ),
                          child: ListView.builder(
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              UserModal member = allUsers[index];
                              return Card(
                                margin: EdgeInsets.only(top: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      FireStoreHelper.fireStoreHelper
                                          .addContact(
                                              senderEmail: user.email,
                                              receiverEmail: member.email)
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    },
                                    title: Text(member.email),
                                    leading: CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(member.profilePic),
                                    ),
                                    trailing: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: orangeTheme,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            // separatorBuilder:
                            //     (context, index) {
                            //   return const Divider();
                            // },
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      backgroundColor: orangeTheme,
      body: Container(
        height: s.height,
        width: s.width,
        margin: EdgeInsetsDirectional.only(top: 20),
        decoration: BoxDecoration(
          color:
              themeController.getTheme ? const Color(0xff1C1B1F) : whiteTheme,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(30),
            topEnd: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 1, bottom: 16, right: 16, left: 16),
          child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .getContactList(email: user.email),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("ERROR : ${snapshot.hasError}"),
                );
              } else if (snapshot.hasData) {
                DocumentSnapshot<Map<String, dynamic>>? snaps = snapshot.data;

                Map data = snaps?.data() as Map;

                List contacts = data['contact'] ?? [];

                return contacts.isNotEmpty
                    ? ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FireStoreHelper.fireStoreHelper
                                .getUserById(email: contacts[index]),
                            builder: (context, userSnap) {
                              if (userSnap.hasData) {
                                DocumentSnapshot? docs = userSnap.data;
                                UserModal userModal = UserModal.fromMap(
                                    data: docs!.data() as Map<String, dynamic>);

                                return Card(
                                  margin: EdgeInsets.only(top: 14),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            MyRoutes.chat_page,
                                            arguments: userModal);
                                      },
                                      leading: CircleAvatar(
                                        foregroundImage:
                                            NetworkImage(userModal.profilePic),
                                      ),
                                      title: Text(
                                        userModal.userName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      subtitle: StreamBuilder(
                                        stream: FireStoreHelper.fireStoreHelper
                                            .getLastMsgAndCounterData(
                                                receiverEmail: userModal.email,
                                                sendereEmail:
                                                    CurrentUser.user.email),
                                        builder: (context, lastMsgSnapshot) {
                                          if (lastMsgSnapshot.hasData) {
                                            DocumentSnapshot<
                                                    Map<String, dynamic>>
                                                snaps2 = lastMsgSnapshot.data!;
                                            Map<String, dynamic> lastMsgData =
                                                snaps2.data() ?? {};
                                            print(lastMsgData['lastMsg']);
                                            return lastMsgData.isNotEmpty
                                                ? Row(
                                                    children: [
                                                      lastMsgData['lastMsg'] ==
                                                              'You Deleted this Message.'
                                                          ? Icon(
                                                              Icons.block,
                                                              size: 20,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          : lastMsgData[
                                                                      'type'] ==
                                                                  "sent"
                                                              ? Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: 20,
                                                                  color: (lastMsgData[
                                                                              'counter'] ==
                                                                          0)
                                                                      ? orangeTheme
                                                                      : Colors
                                                                          .grey)
                                                              : SizedBox(),
                                                      const Gap(5),
                                                      Expanded(
                                                        child: Text(
                                                          lastMsgData[
                                                              'lastMsg'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontStyle: lastMsgData[
                                                                          'lastMsg'] ==
                                                                      'You Deleted this Message.'
                                                                  ? FontStyle
                                                                      .italic
                                                                  : null),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    "Click here to start Chat..!",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  );
                                          } else {
                                            return Text(
                                              "Click here to start Chat..!",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            );
                                          }
                                        },
                                      ),
                                      trailing: Column(
                                        children: [
                                          StreamBuilder(
                                            stream: FireStoreHelper
                                                .fireStoreHelper
                                                .getLastMsgAndCounterData(
                                                    receiverEmail:
                                                        userModal.email,
                                                    sendereEmail:
                                                        CurrentUser.user.email),
                                            builder: (context, timeSnapshot) {
                                              if (timeSnapshot.hasData) {
                                                DocumentSnapshot<
                                                        Map<String, dynamic>>
                                                    snaps2 = timeSnapshot.data!;
                                                Map<String, dynamic>
                                                    timeMsgData =
                                                    snaps2.data() ?? {};
                                                if (timeMsgData.isNotEmpty) {
                                                  DateTime dt = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    int.parse(
                                                        timeMsgData['time']),
                                                  );

                                                  Duration day = DateTime.now()
                                                      .difference(dt);
                                                  String date = "";
                                                  if (day.inDays > 0) {
                                                    print(
                                                        "Day: $day :days : ${day.inDays}");
                                                    if (day.inDays == 1) {
                                                      date = "YesterDay";
                                                    } else if (day.inDays >=
                                                            2 &&
                                                        day.inDays <= 7) {
                                                      date = getWeekDay(
                                                          day: dt.weekday);
                                                    } else {
                                                      date = "${dt.day}"
                                                              .padLeft(2, "0") +
                                                          "/" +
                                                          "${dt.month}"
                                                              .padLeft(2, "0") +
                                                          "/" +
                                                          "${dt.year}";
                                                    }
                                                  } else if (int.parse(day
                                                          .inHours
                                                          .toString()) >
                                                      DateTime.now().hour) {
                                                    date = "YesterDay";
                                                  } else {
                                                    date = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}"
                                                            .padLeft(2, "0") +
                                                        ":" +
                                                        "${dt.minute}"
                                                            .padLeft(2, "0") +
                                                        " " +
                                                        "${(dt.hour > 12) ? "PM" : "Am"}";
                                                  }
                                                  return Text(date,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey));
                                                } else {
                                                  return Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  );
                                                }
                                                ;
                                              } else {
                                                return Text(
                                                  "Click here to start Chat..!",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                );
                                              }
                                            },
                                          ),
                                          const Gap(8),
                                          StreamBuilder(
                                            stream: FireStoreHelper
                                                .fireStoreHelper
                                                .getLastMsgAndCounterData(
                                                    receiverEmail:
                                                        userModal.email,
                                                    sendereEmail:
                                                        CurrentUser.user.email),
                                            builder:
                                                (context, lastMsgSnapshot) {
                                              if (lastMsgSnapshot.hasData) {
                                                DocumentSnapshot<
                                                        Map<String, dynamic>>
                                                    snaps2 =
                                                    lastMsgSnapshot.data!;
                                                Map<String, dynamic>
                                                    lastMsgData =
                                                    snaps2.data() ?? {};
                                                return (lastMsgData.isNotEmpty)
                                                    ? (lastMsgData['counter'] ==
                                                                0 ||
                                                            lastMsgData[
                                                                    'type'] ==
                                                                'sent')
                                                        ? SizedBox()
                                                        : Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    orangeTheme),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              lastMsgData[
                                                                      'counter']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                    : SizedBox();
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                  ),
                                  title: Text("Loading..."),
                                );
                              }
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/images/noFriend.png'),
                              )),
                            ),
                            Text(
                              "Click on + button..!!",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: orangeTheme,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
