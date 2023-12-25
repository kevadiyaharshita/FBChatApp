import 'dart:developer';

import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/modals/chat_modal.dart';
import 'package:chatapp_2/modals/user_modal.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Logger logger = Logger();

  String userCollection = "AllUsers";

  Future<void> updateProfile(
      {required String userName, required String imageUrl}) async {
    User? user = AuthHelper.authHelper.firebaseAuth.currentUser!;
    UserModal userModal = UserModal(
        uid: user.uid,
        userName: userName,
        email: user.email as String,
        profilePic: imageUrl == ''
            ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'
            : imageUrl);
    if (imageUrl == '') {
      imageUrl =
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png';
    }
    await fireStore
        .collection(userCollection)
        .doc(user.email)
        .update({'userName': userName, 'profilePic': imageUrl}).then(
            (value) => logger.i("Data Updated...!"));

    UserModal userModal2 = await getUserByEmail(email: user.email as String);
    CurrentUser.user = userModal2;
  }

  Future<void> deleteForMe(
      {required ChatModal chatModal,
      required String receiverEmail,
      required String sendereEmail}) async {
    Map<String, dynamic> data = chatModal.toMap;
    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .delete();

    //=========================deleteLast===========
    DocumentSnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .get();

    Map<String, dynamic>? data2 = snapshot.data();
    if (data2 != null) {
      if (data2['time'] == data['time']) {
        QuerySnapshot<Map<String, dynamic>> getData = await fireStore
            .collection(userCollection)
            .doc(sendereEmail)
            .collection(receiverEmail)
            .doc("Chats")
            .collection("AllChats")
            .get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> mapData =
            getData.docs;
        List<ChatModal> cm =
            mapData.map((e) => ChatModal.fromMap(data: e.data())).toList();
        ChatModal chatModal = cm[cm.length - 1];

        await fireStore
            .collection(userCollection)
            .doc(sendereEmail)
            .collection(receiverEmail)
            .doc("Data")
            .update({
          'lastMsg': chatModal.msg,
          'time': chatModal.time.millisecondsSinceEpoch.toString(),
          'type': chatModal.type,
        });
      }
    }
  }

  Future<void> updateChat(
      {required ChatModal chatModal,
      required String receiverEmail,
      required String sendereEmail}) async {
    Map<String, dynamic> data = chatModal.toMap;
    if (data['type'] == 'sent') {
      logger.i("true");
      await fireStore
          .collection(userCollection)
          .doc(sendereEmail)
          .collection(receiverEmail)
          .doc("Chats")
          .collection("AllChats")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .set(data);

      data.update('type', (value) => 'rec');

      await fireStore
          .collection(userCollection)
          .doc(receiverEmail)
          .collection(sendereEmail)
          .doc("Chats")
          .collection("AllChats")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .set(data);
    } else {
      logger.e("false");
      await fireStore
          .collection(userCollection)
          .doc(sendereEmail)
          .collection(receiverEmail)
          .doc("Chats")
          .collection("AllChats")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .set(data);

      data.update('type', (value) => 'sent');

      await fireStore
          .collection(userCollection)
          .doc(receiverEmail)
          .collection(sendereEmail)
          .doc("Chats")
          .collection("AllChats")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .set(data);
    }
    //=====================updateLastMsg if Deleted....

    DocumentSnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .get();

    Map<String, dynamic>? data2 = snapshot.data();
    if (data2 != null) {
      if (chatModal.msg == "You Deleted this Message.") {
        logger.i("Condition truee...!");
        if (data2['time'] == data['time']) {
          logger.e("Updated...");
          await fireStore
              .collection(userCollection)
              .doc(sendereEmail)
              .collection(receiverEmail)
              .doc("Data")
              .update({'lastMsg': 'You Deleted this Message.'});

          await fireStore
              .collection(userCollection)
              .doc(receiverEmail)
              .collection(sendereEmail)
              .doc("Data")
              .update({'lastMsg': 'You Deleted this Message.'});
        }
      }
    }
  }

  Future<void> starMessage(
      {required ChatModal chatModal,
      required String receiverEmail,
      required String sendereEmail}) async {
    Map<String, dynamic> data = chatModal.toMap;

    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    if (chatModal.star == "star") {
      if (chatModal.type == "sent") {
        data.addAll({'email': sendereEmail});
      } else {
        data.addAll({'email': receiverEmail});
      }
      await fireStore
          .collection(userCollection)
          .doc(sendereEmail)
          .collection("star")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .set(data);
    } else {
      await fireStore
          .collection(userCollection)
          .doc(sendereEmail)
          .collection("star")
          .doc(chatModal.time.millisecondsSinceEpoch.toString())
          .delete();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStarMessage(
      {required String senderEmail}) {
    return fireStore
        .collection(userCollection)
        .doc(senderEmail)
        .collection("star")
        .snapshots();
  }

  Future<void> updateStatus(
      {required ChatModal chatModal,
      required String receiverEmail,
      required String sendereEmail}) async {
    Map<String, dynamic> data = chatModal.toMap;

    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'sent');

    await fireStore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(sendereEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    //=====================Update Counter==========

    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .update({
      'counter': 0,
    });

    await fireStore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(sendereEmail)
        .doc("Data")
        .update(
      {
        'counter': 0,
      },
    );
  }

  //===================sendMessage============
  Future<void> sendMessage(
      {required ChatModal chatModal,
      required String receiverEmail,
      required String sendereEmail}) async {
    Map<String, dynamic> data = chatModal.toMap;
    data.update('type', (value) => 'sent');

    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'rec');
    data.update('status', (value) => 'notseen');
    await fireStore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(sendereEmail)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    //======================DATA==============
    int counter = await getCounterData(
        receiverEmail: receiverEmail, sendereEmail: sendereEmail);
    counter++;
    await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .set(
      {
        'lastMsg': chatModal.msg,
        'time': chatModal.time.millisecondsSinceEpoch.toString(),
        'type': 'sent',
        'counter': counter,
      },
    );
    logger.i("Counter ...:$counter");
    await fireStore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(sendereEmail)
        .doc("Data")
        .set(
      {
        'lastMsg': chatModal.msg,
        'time': chatModal.time.millisecondsSinceEpoch.toString(),
        'type': 'rec',
        'counter': counter,
      },
    );
  }

  Future<int> getCounterData(
      {required String receiverEmail, required String sendereEmail}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .get();

    Map<String, dynamic>? data = snapshot.data();
    if (data != null) {
      return data['counter'];
    } else {
      return 0;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLastMsgAndCounterData(
      {required String receiverEmail, required String sendereEmail}) {
    return fireStore
        .collection(userCollection)
        .doc(sendereEmail)
        .collection(receiverEmail)
        .doc("Data")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatData(
      {required String receiverEmail, required String senderEmail}) {
    return fireStore
        .collection(userCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("Chats")
        .collection("AllChats")
        .snapshots();
  }

  Future<void> setUserData({required User user}) async {
    UserModal userModal = UserModal(
        uid: user.uid,
        userName: user.displayName ?? "NULL",
        email: user.email as String,
        profilePic: user.photoURL ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png');

    DocumentSnapshot<Map<String, dynamic>> userData =
        await fireStore.collection(userCollection).doc(user.email).get();

    Map<String, dynamic>? data = userData.data();

    if (data != null) {
      print("USer Already Exist....!!");
    } else {
      await fireStore
          .collection(userCollection)
          .doc(user.email)
          .set(userModal.toMap)
          .then((value) => logger.i("Data inserted...!"));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersData() {
    return fireStore.collection(userCollection).snapshots();
  }

  Future<List> getContactData({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snaps =
        await fireStore.collection(userCollection).doc(email).get();
    Map data = snaps.data() as Map;

    return data['contact'] ?? [];
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getContactList(
      {required String email}) {
    return fireStore.collection(userCollection).doc(email).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      {required String email}) {
    return fireStore.collection(userCollection).doc(email).snapshots();
  }

  Future<UserModal> getUserByEmail({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(userCollection).doc(email).get();
    UserModal userModal =
        UserModal.fromMap(data: data.data() as Map<String, dynamic>);
    return userModal;
  }

  Future<void> addContact(
      {required String senderEmail, required String receiverEmail}) async {
    List contacts = await getContactData(email: senderEmail);

    if (!contacts.contains(receiverEmail)) {
      contacts.add(receiverEmail);

      fireStore.collection(userCollection).doc(senderEmail).update({
        'contact': contacts,
      });
    }
    contacts = await getContactData(email: receiverEmail);

    if (!contacts.contains(senderEmail)) {
      contacts.add(senderEmail);

      fireStore.collection(userCollection).doc(receiverEmail).update({
        'contact': contacts,
      });
    }
  }
}
