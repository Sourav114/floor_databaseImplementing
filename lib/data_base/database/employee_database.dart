import 'package:floor/floor.dart';
import 'package:floor_learning/data_base/dao/employee_dao.dart';
import 'package:floor_learning/data_base/entity/employee.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'employee_database.g.dart';

@Database(version:1,entities:[Employee])
abstract class AppDatabase extends FloorDatabase{
  EmployeeDao get employeeDao;
}