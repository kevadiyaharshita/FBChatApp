import 'package:chatapp_2/helper/firestore_helper.dart';
import 'package:chatapp_2/modals/chat_modal.dart';
import 'package:chatapp_2/utils/color_utils.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';

import '../../modals/user_modal.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController chatTextController = TextEditingController();
    UserModal user = ModalRoute.of(context)!.settings.arguments as UserModal;
    Size s = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: orangeTheme,
          foregroundColor: whiteTheme,
          elevation: 0,

          // elevation: 5,
          title: Row(
            children: [
              CircleAvatar(
                // radius: 20,
                foregroundImage: NetworkImage(user.profilePic),
              ),
              const Gap(5),
              Container(
                width: 200,
                child: Text(
                  user.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          height: s.height,
          width: s.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/564x/e0/0b/9a/e00b9a6bce8958583185fd2b49dd6c74.jpg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getChatData(
                    receiverEmail: user.email,
                    senderEmail: CurrentUser.user.email),
                builder: (context, snapshot) {
                  Logger logger = Logger();
                  if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? snaps = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>? data =
                        snaps?.docs;
                    List<ChatModal> chats = data!
                        .map((e) => ChatModal.fromMap(data: e.data()))
                        .toList();

                    chats.forEach((element) {
                      Logger logger = Logger();
                      if (element.type == 'rec') {
                        // logger.e(element.type + element.msg + "updated...");
                        if (element.status == 'notseen') {
                          element.status = "seen";
                          FireStoreHelper.fireStoreHelper.updateStatus(
                              chatModal: element,
                              receiverEmail: user.email,
                              sendereEmail: CurrentUser.user.email);
                        }
                      }
                    });
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        ChatModal chatModal = chats[index];
                        return Row(
                          mainAxisAlignment: chatModal.type == 'sent'
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                children: [
                                  chatModal.type == 'sent' ? Gap(90) : Gap(0),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(
                                            chatModal.type == 'sent' ? 0 : 15),
                                        bottomStart: Radius.circular(
                                            chatModal.type == 'sent' ? 15 : 0),
                                        topEnd: Radius.circular(15),
                                        topStart: Radius.circular(15),
                                      ),
                                    ),
                                    color: chatModal.type == "sent"
                                        ? orangeTheme
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        chatModal.msg,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: chatModal.type == 'sent'
                                                ? Colors.white
                                                : null),
                                      ),
                                    ),
                                  ),
                                  chatModal.type == 'sent' ? Gap(0) : Gap(90),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    return Text("Data Gated...");
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
              Container(
                width: s.width,
                height: 80,
                color: Colors.white.withOpacity(0.7),
                padding: EdgeInsetsDirectional.only(
                    top: 10, bottom: 16, end: 16, start: 16),
                child: TextFormField(
                  controller: chatTextController,
                  decoration: InputDecoration(
                    hintText: "Type a Message here..",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: orangeTheme),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: orangeTheme,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: orangeTheme,
                      ),
                    ),
                    fillColor: greyTheme,
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (chatTextController.text != "") {
                          ChatModal chatModal = ChatModal(
                              chatTextController.text,
                              'sent',
                              DateTime.now(),
                              'notseen');
                          FireStoreHelper.fireStoreHelper
                              .sendMessage(
                                  chatModal: chatModal,
                                  receiverEmail: user.email,
                                  sendereEmail: CurrentUser.user.email)
                              .then((value) => chatTextController.clear());
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: orangeTheme,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (val) {
                    if (chatTextController.text != "") {
                      ChatModal chatModal =
                          ChatModal(val, 'sent', DateTime.now(), 'notseen');
                      FireStoreHelper.fireStoreHelper.sendMessage(
                          chatModal: chatModal,
                          receiverEmail: user.email,
                          sendereEmail: CurrentUser.user.email);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
