import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:chatapp_2/modals/chat_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helper/firestore_helper.dart';
import '../../../utils/color_utils.dart';
import '../chat_page.dart';
import 'date_methods.dart';

List<String> reaction = ['🙏', '❤', '👍', '😂', '😃', '😐'];
Widget container(
    {required Size s,
    required double alignmentX,
    required double alignmentY,
    required ChatModal chatModal,
    required BuildContext context,
    required String recieverEmail,
    required String senderEmail}) {
  return BlurryContainer(
    child: Container(
      height: s.height,
      width: s.width,
      padding: EdgeInsets.all(16),
      // color: Colors.grey.withOpacity(0.3),
      child: Align(
        alignment: Alignment(alignmentX, alignmentY),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: chatModal.type == 'sent'
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Align(
              child: Container(
                height: 65,
                width: 310,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: whiteTheme.withOpacity(0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    reaction.length,
                    (index) => IconButton(
                      onPressed: () {
                        chatModal.react = reaction[index];
                        FireStoreHelper.fireStoreHelper.updateChat(
                            chatModal: chatModal,
                            receiverEmail: recieverEmail,
                            sendereEmail: senderEmail);
                        Navigator.of(context).pop();
                      },
                      icon: Text(
                        reaction[index],
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
              alignment: chatModal.type == 'sent'
                  ? Alignment.topRight
                  : Alignment.topLeft,
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: chatModal.type == 'sent'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                chatModal.type == 'sent' ? const Gap(90) : const Gap(0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd:
                          Radius.circular(chatModal.type == 'sent' ? 0 : 15),
                      bottomStart:
                          Radius.circular(chatModal.type == 'sent' ? 15 : 0),
                      topEnd: Radius.circular(15),
                      topStart: Radius.circular(15),
                    ),
                  ),
                  color: chatModal.type == "sent" ? orangeTheme : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          chatModal.msg,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: chatModal.type == 'sent'
                                  ? Colors.white
                                  : null),
                        ),
                        const Gap(8),
                        Column(
                          children: [
                            const Gap(8),
                            getTimeData(
                                time: chatModal.time.millisecondsSinceEpoch
                                    .toString(),
                                type: chatModal.type),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Align(
              alignment: chatModal.type == 'sent'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Container(
                height: 285,
                width: 250,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteTheme.withOpacity(0.9),
                ),
                child: Column(
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          chatModal.star =
                              (chatModal.star == "star") ? "unstar" : "star";
                          FireStoreHelper.fireStoreHelper.starMessage(
                              chatModal: chatModal,
                              receiverEmail: recieverEmail,
                              sendereEmail: senderEmail);
                          Navigator.of(context).pop();
                        },
                        splashColor: Colors.black,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 15, top: 10, right: 15),
                            child: Row(
                              children: [
                                const Text(
                                  "Star",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                const Icon(
                                  CupertinoIcons.star,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Clipboard.setData(
                            ClipboardData(text: chatModal.msg),
                          ).then(
                            (value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Massage Copied..!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: orangeTheme,
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        splashColor: Colors.black,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 15, top: 10, right: 15),
                            child: Row(
                              children: [
                                const Text(
                                  "Copy",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                const Icon(
                                  Icons.copy,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await Share.share(chatModal.msg);
                        },
                        splashColor: Colors.black,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 15, top: 10, right: 15),
                            child: Row(
                              children: [
                                const Text(
                                  "Share",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.share,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: s.width,
                                height: 184,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  color: orangeTheme,
                                ),
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  children: [
                                    Gap(6),
                                    Row(
                                      children: [
                                        Gap(18),
                                        const Center(
                                          child: Text(
                                            "Delete Message?",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 37,
                                          width: 37,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              CupertinoIcons.multiply,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        Gap(18),
                                      ],
                                    ),
                                    Gap(6),
                                    Container(
                                      width: s.width,
                                      height: 134,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                chatModal.msg =
                                                    "You Deleted this Message.";
                                                // chatModal.star ='unstar';
                                                chatModal.react = 'null';
                                                FireStoreHelper.fireStoreHelper
                                                    .updateChat(
                                                        chatModal: chatModal,
                                                        receiverEmail:
                                                            recieverEmail,
                                                        sendereEmail:
                                                            senderEmail);

                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Delete for Everyone?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: orangeTheme),
                                              )),
                                          Divider(),
                                          TextButton(
                                            onPressed: () {
                                              print("called................");
                                              FireStoreHelper.fireStoreHelper
                                                  .deleteForMe(
                                                      chatModal: chatModal,
                                                      receiverEmail:
                                                          recieverEmail,
                                                      sendereEmail:
                                                          senderEmail);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Delete for Me?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: orangeTheme),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        splashColor: Colors.black,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 15, top: 10, right: 15),
                            child: Row(
                              children: [
                                const Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.delete,
                                  color: orangeTheme,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        splashColor: Colors.black,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 15, top: 10, right: 15),
                            child: Row(
                              children: [
                                const Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.multiply,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
