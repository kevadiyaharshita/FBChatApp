import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/helper/firestore_helper.dart';
import 'package:chatapp_2/modals/user_modal.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:chatapp_2/utils/route_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';

import '../../modals/chat_modal.dart';
import '../../utils/color_utils.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                title: const Text("Add Friend"),
                content: SizedBox(
                  height: 300,
                  width: 300,
                  child: StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.getAllUsersData(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        QuerySnapshot? snap = snapshot2.data;

                        List<QueryDocumentSnapshot> allData = snap!.docs;

                        List<UserModal> allUsers = allData
                            .map(
                                (e) => UserModal.fromMap(data: e.data() as Map))
                            .toList();

                        allUsers.removeWhere(
                            (element) => element.email == user.email);
                        return Container(
                          height: 250,
                          width: 270,
                          child: ListView.builder(
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              UserModal member = allUsers[index];
                              return ListTile(
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
          color: Colors.white,
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
                                    data: docs!.data() as Map);

                                return Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(top: 14),
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
                                          DocumentSnapshot<Map<String, dynamic>>
                                              snaps2 = lastMsgSnapshot.data!;
                                          Map<String, dynamic> lastMsgData =
                                              snaps2.data() ?? {};
                                          return lastMsgData.isNotEmpty
                                              ? Row(
                                                  children: [
                                                    lastMsgData['type'] ==
                                                            "sent"
                                                        ? Icon(Icons.done_all,
                                                            size: 20,
                                                            color: (lastMsgData[
                                                                        'counter'] ==
                                                                    0)
                                                                ? orangeTheme
                                                                : Colors.grey)
                                                        : SizedBox(),
                                                    const Gap(5),
                                                    Expanded(
                                                      child: Text(
                                                        lastMsgData['lastMsg'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
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
                                    trailing: StreamBuilder(
                                      stream: FireStoreHelper.fireStoreHelper
                                          .getLastMsgAndCounterData(
                                              receiverEmail: userModal.email,
                                              sendereEmail:
                                                  CurrentUser.user.email),
                                      builder: (context, lastMsgSnapshot) {
                                        if (lastMsgSnapshot.hasData) {
                                          DocumentSnapshot<Map<String, dynamic>>
                                              snaps2 = lastMsgSnapshot.data!;
                                          Map<String, dynamic> lastMsgData =
                                              snaps2.data() ?? {};
                                          return (lastMsgData.isNotEmpty)
                                              ? (lastMsgData['counter'] == 0 ||
                                                      lastMsgData['type'] ==
                                                          'sent')
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: orangeTheme),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        lastMsgData['counter']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
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
                            // Text(
                            //   "No Contacts yet..!!",
                            //   style:
                            //       TextStyle(fontSize: 24, color: orangeTheme),
                            // ),
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
