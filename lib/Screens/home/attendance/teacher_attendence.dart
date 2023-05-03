import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sms/Services/common.dart';
import 'package:intl/intl.dart';

class TeacherAttendence extends StatefulWidget {
  const TeacherAttendence({super.key});

  @override
  State<TeacherAttendence> createState() => _TeacherAttendenceState();
}

class _TeacherAttendenceState extends State<TeacherAttendence> {
  String? selectedClass;
  int count = 0;
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  void updateValue(String val) {
    setState(() {
      selectedClass = val;
    });
  }

  Future<List<String>> getList() async {
    List<String> list;
    list = (await Common().getTeachers()).classes!.toList();
    if (count++ == 0) {
      setState(() {
        selectedClass = list[0];
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              'Upload Attendence',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade900),
              
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20),
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: FutureBuilder<List<String>>(
                future: getList(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some Error');
                  }
                  if (snapshot.hasData) {
                    return DropdownButton<String>(
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      elevation: 8,
                      focusColor: Colors.blue.shade100,
                      dropdownColor: Colors.blue.shade50,
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.blue.shade500,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      hint: const Text("Select a Class"),
                      value: selectedClass,
                      onChanged: ((String? value) => updateValue(value!)),
                      items:
                          snapshot.data.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            'Class $value',
                            style: TextStyle(
                              color: Colors.blue.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.width / 4,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: Center(
                      child: TextField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(
                            days: 30, hours: 0, minutes: 0, seconds: 0)),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          dateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ))),
              const SizedBox(
                width: 40,
              ),
              ElevatedButton(
                onPressed: (() {}),
                child: const Text('View Student',style: TextStyle(
                    color: Colors.white
                  ),
                ),
              )
            ],
          )
          
          
        ],
      ),
    );
  }

  Widget infoBox(BuildContext context, String? infokey, String? infovalue) {
    return Container(
      height: 60,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.grey.shade100,
      ),
      child: 
      infovalue==""?
      Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              infokey!,
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey.shade600,
              ),
            ),
          )
      :
      
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              infokey!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              infovalue!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  } 
}
