class Message {
  Message({
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.toId,
    required this.type,
  });

  late final String fromId;
  late final String msg;
  late final String read;
  late final String sent;
  late final String toId;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    toId = json['toId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromId'] = fromId;
    data['msg'] = msg;
    data['read'] = read;
    data['sent'] = sent;
    data['toId'] = toId;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image }
