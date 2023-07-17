import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 123, 91, 179)),
          // useMaterial3: ,
        ),
        home: const NotificationPage());
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String dropdownValue = "Default";

  Priority priority = Priority.defaultPriority;
  Importance importance = Importance.defaultImportance;

  final List messagePriority = [
    Priority.min,
    Priority.low,
    Priority.high,
    Priority.max,
    Priority.defaultPriority
  ];

  final List importanceList = [
    Importance.min,
    Importance.low,
    Importance.high,
    Importance.max,
    Importance.defaultImportance
  ];

  @override
  void initState() {
    configNotification(plugin: localNotificationsPlugin);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Testing"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DirectiveText(text: "Notification Title:"),
              InputText(controller: _titleController, hint: "Title"),
              const SizedBox(height: 10),
              const DirectiveText(text: "Notification Body:"),
              InputText(controller: _messageController, hint: "Message"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Priority: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                    value: dropdownValue,
                    items: <String>['Min', 'Low', 'High', 'Max', "Default"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      switch (value) {
                        case "Min":
                          priority = Priority.min;
                          importance = Importance.min;
                          break;
                        case "Low":
                          priority = Priority.low;
                          importance = Importance.low;
                          break;
                        case "High":
                          priority = Priority.high;
                          importance = Importance.high;
                          break;
                        case "Max":
                          priority = Priority.max;
                          importance = Importance.max;
                        case "Default":
                          priority = Priority.defaultPriority;
                          importance = Importance.defaultImportance;
                          break;
                      }
                      dropdownValue = value!;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String title = _titleController.text.trim();
                              String message = _messageController.text.trim();

                              await sendNotification(
                                plugin: localNotificationsPlugin,
                                title: title,
                                message: message,
                                importance: importance,
                                priority: priority,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Message Sent")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide())),
                          child: const Text("Send"),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  configNotification({required FlutterLocalNotificationsPlugin plugin}) async {
    const androidInitialize =
        AndroidInitializationSettings("mipmap/ic_launcher");
    const iosInitialize = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    await localNotificationsPlugin.initialize(initializationSettings);
  }
}

class DirectiveText extends StatelessWidget {
  const DirectiveText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

sendNotification({
  required FlutterLocalNotificationsPlugin plugin,
  required String title,
  required String message,
  required Importance importance,
  required Priority priority,
}) async {
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    "Test Notification",
    "channel_name",
    playSound: true,
    importance: importance,
    priority: priority,
  );

  final details = NotificationDetails(
      android: androidDetails, iOS: const DarwinNotificationDetails());

  await plugin.show(0, title, message, details);
}
