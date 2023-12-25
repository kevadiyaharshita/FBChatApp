class ChatModal {
  String msg, type, status, react, star;
  DateTime time;

  ChatModal(
      {required this.msg,
      required this.type,
      required this.time,
      required this.status,
      required this.react,
      required this.star});

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      msg: data['msg'],
      type: data['type'],
      time: DateTime.fromMillisecondsSinceEpoch(
        int.parse(data['time']),
      ),
      status: data['status'],
      react: data['react'],
      star: data['star'],
    );
  }

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'type': type,
        'time': time.millisecondsSinceEpoch.toString(),
        'status': status,
        'react': react,
        'star': star
      };
}
