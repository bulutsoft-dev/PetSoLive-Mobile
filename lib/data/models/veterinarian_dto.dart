class VeterinarianDto {
  final int id;
  final int userId;
  final String userName;
  final String qualifications;
  final String clinicAddress;
  final String clinicPhoneNumber;
  final DateTime appliedDate;
  final String status;

  VeterinarianDto({
    required this.id,
    required this.userId,
    required this.userName,
    required this.qualifications,
    required this.clinicAddress,
    required this.clinicPhoneNumber,
    required this.appliedDate,
    required this.status,
  });

  factory VeterinarianDto.fromJson(Map<String, dynamic> json) {
    return VeterinarianDto(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      qualifications: json['qualifications'],
      clinicAddress: json['clinicAddress'],
      clinicPhoneNumber: json['clinicPhoneNumber'],
      appliedDate: DateTime.parse(json['appliedDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'qualifications': qualifications,
    'clinicAddress': clinicAddress,
    'clinicPhoneNumber': clinicPhoneNumber,
    'appliedDate': appliedDate.toIso8601String(),
    'status': status,
  };
} 