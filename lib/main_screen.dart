import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;
import 'package:task_app/patients_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvc3RhZ2luZy5teWVzYWRvYy5jb21cL2FwaVwvdjFcL2RMb2dpbiIsImlhdCI6MTY2MTMxNDQ5MywiZXhwIjoxNjYzOTQyNDkzLCJuYmYiOjE2NjEzMTQ0OTMsImp0aSI6InJ5VWpEVnpuQjZERXR0bnciLCJzdWIiOjExOCwicHJ2IjoiODdlMGFmMWVmOWZkMTU4MTJmZGVjOTcxNTNhMTRlMGIwNDc1NDZhYSJ9.8ZNgDz_vIlINkECdEfcmD1hRIb7guKtg05MzVa0Im4s';

  int _page = 1;
  bool _hasNextPage = true;

  bool _isFirstLoading = false;
  bool _isLoadMoreLoading = false;
  List<dynamic> _patientsData = [];

  ScrollController _scrollController = ScrollController();

  // First time this method will call
  Future<void> _firstLoad() async {
    setState(() {
      _isFirstLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse(
              "https://staging.myesadoc.com/api/v1/dRecommendationList?page=$_page"),
          headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('First print ---> ${jsonData['recomlist']['data']}');
        setState(() {
          _patientsData = jsonData['recomlist']['data'];
        });
      } else {
        debugPrint('${response.statusCode} ---------');
      }
    } catch (error) {
      debugPrint(error.toString());
    }

    setState(() {
      _isFirstLoading = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoading == false &&
        _isLoadMoreLoading == false &&
        (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent)) {
      setState(() {
        _isLoadMoreLoading = true;
      });

      _page += 1;

      try {
        final response = await http.get(
            Uri.parse(
                "https://staging.myesadoc.com/api/v1/dRecommendationList?page=$_page"),
            headers: {'Authorization': 'Bearer $_token'});

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          final List<dynamic> fetchedList = jsonData['recomlist']['data'];

          print("Second point=--> $fetchedList");
          if (fetchedList.isNotEmpty) {
            setState(() {
              _patientsData.addAll(fetchedList);
            });
          } else {
            // Means there is no more Data
            setState(() {
              _hasNextPage = false;
            });
          }
        } else {
          debugPrint('${response.statusCode} ---------');
        }
      } catch (error) {
        debugPrint(error.toString());
      }

      setState(() {
        _isLoadMoreLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _scrollController.addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Patient's List",
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
          child: _isFirstLoading
              ? const Center(
                  child: SpinKitChasingDots(color: Colors.blue),
                )
              : Column(
                  children: [
                    patientsList(),
                    // when the _loadMore function is running
                    if (_isLoadMoreLoading == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    // When nothing else to load

                    // if (_hasNextPage == false)
                    //   Container(
                    //     padding: const EdgeInsets.only(top: 20, bottom: 30),
                    //     color: Colors.amber.withOpacity(0.6),
                    //     child: const Center(
                    //       child: Text(
                    //         'No more data',
                    //       ),
                    //     ),
                    //   )
                  ],
                )),
    );
  }

  Flexible patientsList() {
    return Flexible(
        child: ListView.builder(
      controller: _scrollController,
      itemCount: _patientsData.length,
      itemBuilder: (_, index) {
        return PatientsList(patientsData: _patientsData, index: index);
      },
    ));
  }
}

// Card(
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//           child: ListTile(
//             title: Text(_patientsData[index]['full_name']),
//             subtitle: Text(_patientsData[index]['plan_name']),
//           ),
//         );