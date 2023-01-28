import 'package:dusty_dust_project/Model/status_model.dart';
import 'package:dusty_dust_project/Model/stat_model.dart';

class StatAndStatusModel {
  final ItemCode itemCode;
  final StatusModel status;
  final StatModel stat;

  StatAndStatusModel({
    required this.itemCode,
    required this.status,
    required this.stat,
  });
}
