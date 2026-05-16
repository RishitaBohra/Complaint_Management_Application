

class Complaint {
  final int id;
  final String complaintNumber;
  final String name;
  final String date;
  final String contact;
  final String block;
  final String complaintType;
  final String timeCarpentryCivil;
  final String timePlumbingElectrical;
  final String description;
  final String status;
  final int? staffId;
  final String? createdAt;
  final int? userId; 

  Complaint({
    required this.id,
    required this.complaintNumber,
    required this.name,
    required this.date,
    required this.contact,
    required this.block,
    required this.complaintType,
    required this.timeCarpentryCivil,
    required this.timePlumbingElectrical,
    required this.description,
    required this.status,
    this.staffId,
    this.createdAt,
    this.userId,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      complaintNumber: json['complaintNumber'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      contact: json['contact'] ?? '',
      block: json['block'] ?? '',
      complaintType: json['complaintType'] ?? '',
      timeCarpentryCivil: json['timeCarpentryCivil'] ?? '',
      timePlumbingElectrical: json['timePlumbingElectrical'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      staffId: json['staffId'],
      createdAt: json['createdAt'],
      userId: json['userId'], 
    );
  }
}
