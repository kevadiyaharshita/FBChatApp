import 'package:chatapp_2/modals/chat_modal.dart';
import 'package:chatapp_2/modals/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/current_user_modal.dart';
import 'chat_dialouge.dart';
import 'date_methods.dart';

Widget getChatCard({
  required ChatModal chatModal,
  required GlobalKey key,
  required double alignmentX,
  required double alignmentY,
  required Size s,
  required BuildContext context,
  required UserModal user,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, right: 12),
    child: Row(
      mainAxisAlignment: chatModal.type == 'sent'
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        chatModal.type == 'sent' ? const Gap(90) : const Gap(0),
        GestureDetector(
          onLongPress: () {
            RenderBox box =
                key?.currentContext?.findRenderObject() as RenderBox;
            Offset position = box.localToGlobal(
              const Offset(0, -70),
            ); //this is global position
            double y = position.dy;
            double x = position.dx;
            alignmentX = (x - s.width / 2) / (s.width / 2);
            alignmentY = (y - s.height / 2) / (s.height / 2);

            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(0),
                    children: [
                      container(
                          alignmentX: alignmentX,
                          alignmentY: alignmentY,
                          chatModal: chatModal,
                          s: s,
                          context: context,
                          recieverEmail: user.email,
                          senderEmail: CurrentUser.user.email),
                    ]);
              },
            );
          },
          child: Stack(
            children: [
              Container(
                margin: (chatModal.react == 'null')
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Card(
                  key: key,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd:
                          Radius.circular(chatModal.type == 'sent' ? 0 : 15),
                      bottomStart:
                          Radius.circular(chatModal.type == 'sent' ? 15 : 0),
                      topEnd: const Radius.circular(15),
                      topStart: const Radius.circular(15),
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
                              fontSize:
                                  (chatModal.msg == 'You Deleted this Message.')
                                      ? 16
                                      : 18,
                              color: chatModal.type == 'sent'
                                  ? (chatModal.msg ==
                                          'You Deleted this Message.')
                                      ? Colors.white.withOpacity(
                                          0.6,
                                        )
                                      : Colors.white
                                  : (chatModal.msg ==
                                          'You Deleted this Message.')
                                      ? Colors.grey
                                      : null,
                              fontStyle:
                                  (chatModal.msg == 'You Deleted this Message.')
                                      ? FontStyle.italic
                                      : null),
                        ),
                        const Gap(8),
                        Column(
                          children: [
                            const Gap(8),
                            Row(
                              children: [
                                (chatModal.star == "star")
                                    ? Icon(
                                        Icons.star,
                                        color: chatModal.type == 'sent'
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.grey.withOpacity(0.7),
                                        size: 15,
                                      )
                                    : const SizedBox(),
                                getTimeData(
                                    time: chatModal.time.millisecondsSinceEpoch
                                        .toString(),
                                    type: chatModal.type),
                                const Gap(3),
                                (chatModal.type == 'sent')
                                    ? Icon(
                                        Icons.done_all,
                                        size: 20,
                                        color: (chatModal.status == 'seen')
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
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
              ),
              (chatModal.react == 'null')
                  ? const SizedBox()
                  : Positioned(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.grey,
                                // offset: Offset(2, 2),
                                blurRadius: 5),
                          ],
                        ),
                        child: Text(chatModal.react),
                        alignment: Alignment.center,
                      ),
                      top: 40,
                      right: (chatModal.type == 'sent') ? 10 : null,
                      left: (chatModal.type == 'rec') ? 10 : null,
                    ),
            ],
          ),
        ),
        chatModal.type == 'sent' ? const Gap(0) : const Gap(90),
      ],
    ),
  );
}
