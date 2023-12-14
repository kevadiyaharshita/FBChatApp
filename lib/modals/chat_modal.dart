class ChatModal {
  String msg, type, status;
  DateTime time;

  ChatModal(this.msg, this.type, this.time, this.status);

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      data['msg'],
      data['type'],
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(data['time']),
      ),
      data['status'],
    );
  }

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'type': type,
        'time': time.millisecondsSinceEpoch.toString(),
        'status': status
      };
}
