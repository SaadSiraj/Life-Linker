/// JUNIOR DEVLOPER MISS MODELS WORING IN 1 FILE
library;

class UserModel {
  final String caregiverName;
  final String caregiverEmail;
  final String caregiverPhone;
  final String patientName;
  final int patientAge;
  final String patientCondition;
  final String patientBloodGroup;
  final String patientEmergencyContact;

  const UserModel({
    required this.caregiverName,
    required this.caregiverEmail,
    required this.caregiverPhone,
    required this.patientName,
    required this.patientAge,
    required this.patientCondition,
    required this.patientBloodGroup,
    required this.patientEmergencyContact,
  });

  UserModel copyWith({
    String? caregiverName,
    String? caregiverEmail,
    String? caregiverPhone,
    String? patientName,
    int? patientAge,
    String? patientCondition,
    String? patientBloodGroup,
    String? patientEmergencyContact,
  }) {
    return UserModel(
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
      caregiverPhone: caregiverPhone ?? this.caregiverPhone,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientCondition: patientCondition ?? this.patientCondition,
      patientBloodGroup: patientBloodGroup ?? this.patientBloodGroup,
      patientEmergencyContact:
          patientEmergencyContact ?? this.patientEmergencyContact,
    );
  }
}

// class UserModel {
//   final String? uid;
//   final String? name;
//   final String? email;
//   final String? phone;
//   final String? profileImage;
//   final String? role; // patient, caregiver, admin
//   final bool? isAdmin;

//   // Patient Specific Fields
//   final int? age;
//   final String? condition;
//   final String? bloodGroup;
//   final String? emergencyContact;

//   // Caregiver Specific Fields
//   final String? relation; // son, daughter, wife etc

//   const UserModel({
//     this.uid,
//     this.name,
//     this.email,
//     this.phone,
//     this.profileImage,
//     this.role,
//     this.isAdmin,
//     this.age,
//     this.condition,
//     this.bloodGroup,
//     this.emergencyContact,
//     this.relation,
//   });

//   UserModel copyWith({
//     String? uid,
//     String? name,
//     String? email,
//     String? phone,
//     String? profileImage,
//     String? role,
//     bool? isAdmin,
//     int? age,
//     String? condition,
//     String? bloodGroup,
//     String? emergencyContact,
//     String? relation,
//   }) {
//     return UserModel(
//       uid: uid ?? this.uid,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       profileImage: profileImage ?? this.profileImage,
//       role: role ?? this.role,
//       isAdmin: isAdmin ?? this.isAdmin,
//       age: age ?? this.age,
//       condition: condition ?? this.condition,
//       bloodGroup: bloodGroup ?? this.bloodGroup,
//       emergencyContact: emergencyContact ?? this.emergencyContact,
//       relation: relation ?? this.relation,
//     );
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'],
//       name: map['name'],
//       email: map['email'],
//       phone: map['phone'],
//       profileImage: map['profileImage'],
//       role: map['role'],
//       isAdmin: map['isAdmin'],

//       age: map['age'],
//       condition: map['condition'],
//       bloodGroup: map['bloodGroup'],
//       emergencyContact: map['emergencyContact'],

//       relation: map['relation'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'profileImage': profileImage,
//       'role': role,
//       'isAdmin': isAdmin,

//       'age': age,
//       'condition': condition,
//       'bloodGroup': bloodGroup,
//       'emergencyContact': emergencyContact,

//       'relation': relation,
//     };
//   }
// }
