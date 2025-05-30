// import 'dart:convert';

// void main() {
//   var decoded = jsonEncode(dataFake);
//   final a = rasiberModelFromJson(decoded);
//   print(a.profile?.levellingData?.status ?? 'tidak ada');
// }

// final dataFake = {
//   "status": "ok",
//   "error": null,
//   "profile": {
//     "levelling_data": {
//       "rasib": true,
//       "status": "draft",
//       "period_desc": "akhir Agustus 2025",
//       "module_name": "Silsilah Ilmiyyah 1 : Belajar Tauhid",
//       "module_code": "SI1"
//     }
//   }
// };

// final dataLevel = {
  
// };

// RasiberModel rasiberModelFromJson(String str) =>
//     RasiberModel.fromJson(json.decode(str));

// String rasiberModelToJson(RasiberModel data) => json.encode(data.toJson());

// class RasiberModel {
//   String? status;
//   dynamic error;
//   Profile? profile;

//   RasiberModel({
//     this.status,
//     this.error,
//     this.profile,
//   });

//   factory RasiberModel.fromJson(Map<String, dynamic> json) => RasiberModel(
//         status: json["status"],
//         error: json["error"],
//         profile:
//             json["profile"] == null ? null : Profile.fromJson(json["profile"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "error": error,
//         "profile": profile?.toJson(),
//       };
// }

// class Profile {
//   LevellingData? levellingData;

//   Profile({
//     this.levellingData,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) => Profile(
//         levellingData: json["levelling_data"] == null
//             ? null
//             : LevellingData.fromJson(json["levelling_data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "levelling_data": levellingData?.toJson(),
//       };
// }

// class LevellingData {
//   bool? rasib;
//   String? status;
//   String? periodDesc;
//   String? moduleName;
//   String? moduleCode;

//   LevellingData({
//     this.rasib,
//     this.status,
//     this.periodDesc,
//     this.moduleName,
//     this.moduleCode,
//   });

//   factory LevellingData.fromJson(Map<String, dynamic> json) => LevellingData(
//         rasib: json["rasib"],
//         status: json["status"],
//         periodDesc: json["period_desc"],
//         moduleName: json["module_name"],
//         moduleCode: json["module_code"],
//       );

//   Map<String, dynamic> toJson() => {
//         "rasib": rasib,
//         "status": status,
//         "period_desc": periodDesc,
//         "module_name": moduleName,
//         "module_code": moduleCode,
//       };
// }
