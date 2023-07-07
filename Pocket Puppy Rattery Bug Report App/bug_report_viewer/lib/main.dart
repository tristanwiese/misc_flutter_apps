import 'package:bug_report_viewer/Models/report_model.dart';
import 'package:bug_report_viewer/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomNavBarIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Bug/Improvement Reports"),
        ),
        body: body());
  }

  body() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconText(
                iconColor: Colors.grey,
                text: "Low Priority",
              ),
              IconText(
                iconColor: Colors.yellow,
                text: "Medium Priority",
              ),
            ],
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconText(
              iconColor: Colors.red,
              text: "High Priority",
            ),
            IconText(
              iconColor: Colors.green,
              text: "Fixed",
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: PageView(
            controller: _pageController,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Bugs',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("bugReports")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Waiting");
                          }
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              reports = snapshot.data!.docs;

                          reports = sortReports(reports);

                          if (reports.isEmpty ||
                              reports.length == 1 &&
                                  reports[0]["title"] == "Dummy") {
                            return const Text("No Reports");
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 194,
                            child: ListView.builder(
                                itemCount: reports.length,
                                itemBuilder: (context, index) {
                                  final report = Report();
                                  report.setData = reports[index];
                                  if (report.title == "Dummy") {
                                    return Container();
                                  }

                                  Color? backgroundColor;
                                  switch (report.state) {
                                    case "mediumPriority":
                                      backgroundColor = Colors.yellow[200];
                                      break;
                                    case "highPriority":
                                      backgroundColor = Colors.red[200];
                                      break;
                                    case "fixed":
                                      backgroundColor = Colors.green[200];
                                      break;
                                    case "new":
                                      backgroundColor = Colors.white;
                                      break;
                                    default:
                                      backgroundColor = Colors.grey;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: report.state == "new"
                                              ? const BorderSide(
                                                  color: Colors.black45)
                                              : BorderSide.none),
                                      color: backgroundColor ?? Colors.grey,
                                      child: ListTile(
                                        onLongPress: () => priorityPicker(
                                            report, "bugReports"),
                                        onTap: () => viewDiscription(report),
                                        title: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Title: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    report.title.toString(),
                                                    softWrap: true,
                                                    // maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Area: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(report.area.toString()),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "User: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    report.user.toString(),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Date: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    "${report.date!.year}/${report.date!.month}/${report.date!.day} - ${report.date!.hour}:${report.date!.minute}"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: (report.state == "fixed")
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red[300],
                                                ),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection("bugReports")
                                                      .doc(report.id)
                                                      .delete();
                                                },
                                              )
                                            : (report.state == "new")
                                                ? Icon(
                                                    Icons
                                                        .notification_important_outlined,
                                                    color: Colors.red[300],
                                                  )
                                                : null,
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Improvements',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("improvements")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Waiting");
                          }
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              reports = snapshot.data!.docs;
                          reports = sortReports(reports);

                          if (reports.isEmpty ||
                              reports.length == 1 &&
                                  reports[0]["title"] == "Dummy") {
                            return const Text("No Reports");
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 194,
                            child: ListView.builder(
                                itemCount: reports.length,
                                itemBuilder: (context, index) {
                                  final report = Report();
                                  report.setData = reports[index];
                                  if (report.title == "Dummy") {
                                    return Container();
                                  }

                                  Color? backgroundColor;
                                  switch (report.state) {
                                    case "mediumPriority":
                                      backgroundColor = Colors.yellow[200];
                                      break;
                                    case "highPriority":
                                      backgroundColor = Colors.red[200];
                                      break;
                                    case "fixed":
                                      backgroundColor = Colors.green[200];
                                      break;
                                    case "new":
                                      backgroundColor = Colors.white;
                                      break;
                                    default:
                                      backgroundColor = Colors.grey;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: report.state == "new"
                                              ? const BorderSide(
                                                  color: Colors.black45)
                                              : BorderSide.none),
                                      color: backgroundColor ?? Colors.grey,
                                      child: ListTile(
                                        onLongPress: () => priorityPicker(
                                            report, "improvements"),
                                        onTap: () => viewDiscription(report),
                                        title: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Title: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  report.title.toString(),
                                                  softWrap: true,
                                                )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Area: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(report.area.toString()),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "User: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    report.user.toString(),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Date: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    "${report.date!.year}/${report.date!.month}/${report.date!.day} - ${report.date!.hour}:${report.date!.minute}"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: (report.state == "fixed")
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red[300],
                                                ),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "improvements")
                                                      .doc(report.id)
                                                      .delete();
                                                },
                                              )
                                            : (report.state == "new")
                                                ? Icon(
                                                    Icons
                                                        .notification_important_outlined,
                                                    color: Colors.red[300],
                                                  )
                                                : null,
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  priorityPicker(report, colletion) {
    showDialog(
      context: context,
      builder: (context) {
        final reportUpdate =
            FirebaseFirestore.instance.collection(colletion).doc(report.id);

        return AlertDialog(
          title: const Text("Select Priority"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Done"),
            ),
          ],
          content: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            reportUpdate.update({"state": "lowPriority"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text("Low Priority"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            reportUpdate.update({"state": "mediumPriority"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[200]),
                          child: const Text("Medium Priority"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            reportUpdate.update({"state": "highPriority"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[200]),
                          child: const Text("High Priority"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            reportUpdate.update({"state": "fixed"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[200]),
                          child: const Text("Fixed"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  viewDiscription(Report report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Description"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Done"))
          ],
          content: SizedBox(
            height: 100,
            child: SingleChildScrollView(
              child: Center(
                child: Text(report.description!),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<QueryDocumentSnapshot<Map<String, dynamic>>> sortReports(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> reports) {
  int highPriorityCount = 0;
  int mediumPriorityCount = 0;
  int newCount = 0;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedReports = [];

  for (int i = 0; i < reports.length; i++) {
    String priority = reports[i]["state"];
    switch (priority) {
      case "new":
        sortedReports.insert(0, reports[i]);
        newCount += 1;
        break;
      case "highPriority":
        sortedReports.insert(newCount, reports[i]);
        highPriorityCount += 1;
        break;
      case "fixed":
        sortedReports.add(reports[i]);
        break;
      case "mediumPriority":
        sortedReports.insert(highPriorityCount + newCount, reports[i]);
        mediumPriorityCount += 1;
        break;
      case "lowPriority":
        sortedReports.insert(
            mediumPriorityCount + highPriorityCount + newCount, reports[i]);
        break;
    }
  }
  return sortedReports;
}

class IconText extends StatelessWidget {
  const IconText({super.key, required this.iconColor, required this.text});

  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.square_rounded,
          color: iconColor,
        ),
        Text(text)
      ],
    );
  }
}
