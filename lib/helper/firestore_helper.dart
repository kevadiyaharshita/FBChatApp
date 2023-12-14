import 'dart:developer';

import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/modals/chat_modal.dart';
import 'package:chatapp_2/modals/user_modal.dart';
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

  Future<void> updateProfile({required String userName}) async {
    User? user = AuthHelper.authHelper.firebaseAuth.currentUser!;
    UserModal userModal = UserModal(
        uid: user.uid,
        userName: userName,
        email: user.email as String,
        profilePic: user.photoURL ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png');

    await fireStore.collection(userCollection).doc(user.email).update(
        {'userName': userName}).then((value) => logger.i("Data Updated...!"));
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
        'type': 'sent',
        'counter': counter,
      },
    );
    logger.i("Counter ...:$counter");
    // counter = await getCounterData(
    //     receiverEmail: receiverEmail, sendereEmail: sendereEmail);
    await fireStore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(sendereEmail)
        .doc("Data")
        .set(
      {
        'lastMsg': chatModal.msg,
        'type': 'rec',
        'counter': counter,
      },
    );

    // Map<String, dynamic> data2 = await getLastMessagesData(email: sendereEmail);
    //
    // List lastMsg = ["${chatModal.msg}", "sent"];
    //
    // data2.update(receiverEmail, (value) => lastMsg);
    // fireStore
    //     .collection(userCollection)
    //     .doc(sendereEmail)
    //     .update({'lastMsg': data2});
    //
    // data2 = await getLastMessagesData(email: receiverEmail);
    //
    // lastMsg = ["${chatModal.msg}", "rec"];
    //
    // data2.update(sendereEmail, (value) => lastMsg);
    // fireStore
    //     .collection(userCollection)
    //     .doc(receiverEmail)
    //     .update({'lastMsg': data2});
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
    UserModal userModal = UserModal.fromMap(data: data.data() as Map);
    return userModal;
  }

  Future<Map<String, dynamic>> getLastMessagesData(
      {required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snaps =
        await fireStore.collection(userCollection).doc(email).get();
    Map data = snaps.data() as Map;

    return data['lastMsg'] ?? {};
  }

  Future<void> addContact(
      {required String senderEmail, required String receiverEmail}) async {
    List contacts = await getContactData(email: senderEmail);
    // Map<String, dynamic> lastMsgs =
    //     await getLastMessagesData(email: senderEmail);

    if (!contacts.contains(receiverEmail)) {
      contacts.add(receiverEmail);
      // lastMsgs.addAll({
      //   receiverEmail: ["", ""]
      // });
      fireStore.collection(userCollection).doc(senderEmail).update({
        'contact': contacts,
        // 'lastMsg': lastMsgs,
      });
    }

    contacts = await getContactData(email: receiverEmail);

    // lastMsgs = await getLastMessagesData(email: receiverEmail);
    if (!contacts.contains(senderEmail)) {
      contacts.add(senderEmail);
      // lastMsgs.addAll({
      //   senderEmail: ["", ""]
      // });
      fireStore.collection(userCollection).doc(receiverEmail).update({
        'contact': contacts,
        // 'lastMsg': lastMsgs,
      });
    }
  }
}
