final String tableQrCodes = 'qrcodes';

class QrCodeFields{
  static final String id = '_id';
  static final String text = 'text';
  static final String creationTime = 'creation_time';
}

class QrCode{
  final int? id;
  final String text;
  final DateTime creationTime;

  const QrCode({
    this.id,
    required this.text,
    required this.creationTime,
  });

  Map<String, Object?> toJson() => {
    QrCodeFields.id: id,
    QrCodeFields.text: text,
    QrCodeFields.creationTime: creationTime.toIso8601String(),
  };

  static QrCode fromJson(Map<String, Object?> json) => QrCode(
    id: json[QrCodeFields.id] as int,
    text: json[QrCodeFields.text] as String,
    creationTime: DateTime.parse(json[QrCodeFields.creationTime] as String),
  );
}