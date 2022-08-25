import 'package:flutter/material.dart';

class PatientsList extends StatelessWidget {
  List<dynamic> patientsData;
  int index;
  PatientsList({Key? key, required this.patientsData, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
          // height: size.height * 0.13,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${patientsData[index]['full_name']}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    CircleAvatar(
                        radius: 20,
                        child:
                            "https://th.bing.com/th/id/OIP.94ItPwXooaa4zw_5t_BxQQHaIY?pid=ImgDet&rs=1" !=
                                    null
                                ? Image.network(
                                    "https://th.bing.com/th/id/OIP.94ItPwXooaa4zw_5t_BxQQHaIY?pid=ImgDet&rs=1",
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.person))
                  ],
                ),
                Text(
                  '${patientsData[index]['email']}',
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan Name: ${patientsData[index]['plan_name']}',
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6)),
                    ),
                    Text(
                      'User Id: ${patientsData[index]['user_id']}',
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
