import 'package:floor_learning/data_base/dao/employee_dao.dart';
import 'package:floor_learning/data_base/database/employee_database.dart';
import 'package:floor_learning/screen/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('edmt_database.db').build();
  final dao = database.employeeDao;
  runApp(MyApp(dao: dao,));
}
class MyApp extends StatelessWidget {
  final EmployeeDao dao;
  const MyApp({super.key, required this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Floor Database',dao: dao)
    );
  }
}

