import 'package:faker/faker.dart';
import 'package:floor_learning/data_base/dao/employee_dao.dart';
import 'package:floor_learning/data_base/entity/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.dao});
  final EmployeeDao dao;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController controller = TextEditingController();
  String num='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () async{
            final employee = Employee(
                firstName: Faker().person.firstName(),
                lastName: Faker().person.lastName(),
                email: Faker().internet.email(),
            );
             await widget.dao.insertEmployee(employee);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add'),duration: Duration(milliseconds: 500),));
          }
              , icon: const Icon(Icons.add)),
          IconButton(onPressed: () async{
            await widget.dao.deleteAllEmployee();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted'),duration: Duration(milliseconds: 500),));
          }
              , icon: const Icon(Icons.clear))
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: widget.dao.getAllEmployee(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Center(
                    child: Text('${snapshot.error}')
                );
              }
              else if(snapshot.hasData)
              {
                var listEmployee = snapshot.data as List<Employee>;
                return ListView.builder(
                    itemCount: listEmployee.length,
                    itemBuilder: (context,index){
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) async{
                                final updateEmployee = listEmployee[index];

                                updateEmployee.firstName = 'updated';
                                updateEmployee.lastName = Faker().person.lastName();
                                updateEmployee.email = Faker().internet.email();

                                await widget.dao.updateEmployee(updateEmployee);
                              },
                              label: 'Update',
                              icon: Icons.edit,
                              backgroundColor: Colors.blueAccent,
                            ),
                            SlidableAction(
                              onPressed: (context) async{
                                final deleteEmployee = listEmployee[index];
                                await widget.dao.deleteEmployee(deleteEmployee);
                              },
                              label: 'Remove',
                              icon: Icons.delete,
                              backgroundColor: Colors.greenAccent,
                            ),
                            // Add more actions as needed
                          ],
                        ),
                        child: ListTile(
                          title: Text('${listEmployee[index].firstName} ${listEmployee[index].lastName}'),
                          subtitle: Text(listEmployee[index].email),
                        ),
                      );
                    }
                );
              }
              else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 80,
              left: 10,
              right: 100,
              child: Container(
                color: Colors.white,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('Search'),
          onPressed: (){
            widget.dao.getAllEmployeeById(int.parse(num));
            setState(() {
              num=controller.text;
              debugPrint(num);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: StreamBuilder(
                  stream: widget.dao.getAllEmployeeById(int.parse(num)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      debugPrint(snapshot.hasData.toString());
                      return const Text('Loading...');
                    }
                    var listEmployee = snapshot.data as List<Employee>;
                    if (listEmployee.isEmpty) {
                      return const Text('No employee found for the given ID');
                    }
                    return Text('${listEmployee[0]}');
                  },
                ),
              ),
            );
          }
      ),
    );
  }
}

