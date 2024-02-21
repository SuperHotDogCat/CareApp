import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'pages.dart';
import 'config.dart';
//ios build, firebase iosを追加して手順に従う->https://qiita.com/kasa_le/items/fed9f25b92091bd162ce & https://zenn.dev/popy1017/articles/b9f3e46b5efeb79af1f7

final configrations = Configurations();
Future<void> init() async {
  //これ絶対に必要, initもしろ
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: configrations.apiKey,
          appId: configrations.appId,
          messagingSenderId: configrations.messagingSenderId,
          projectId: configrations.projectId));

  // FCM用の設定 通知権限のリクエスト
  final messagingInstance = FirebaseMessaging.instance;
  NotificationSettings settings = await messagingInstance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  final fcmToken = await messagingInstance.getToken();

  // トークンの取得
  debugPrint('fcmToken: $fcmToken');

  // TODO: メッセージの受信
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    if (message.notification != null) {
      debugPrint('${message.notification!.title}');
      debugPrint('${message.notification!.body}');
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init(); //Firebase Initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // これを追
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LogInPage(),
    );
  }
}
