import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages.dart';
import 'config.dart';
//ios build, firebase iosを追加して手順に従う->https://qiita.com/kasa_le/items/fed9f25b92091bd162ce & https://zenn.dev/popy1017/articles/b9f3e46b5efeb79af1f7

final configrations = Configurations();

Future<void> init() async {
  //これ絶対に必要, initもしろ
  await Firebase.initializeApp(
      name: 'flutterapp',
      options: FirebaseOptions(
          apiKey: configrations.apiKey,
          appId: configrations.appId,
          messagingSenderId: configrations.messagingSenderId,
          projectId: configrations.projectId));

  // FCM用の設定 通知権限のリクエスト
  final messagingInstance = FirebaseMessaging.instance;
  final fcmToken = await messagingInstance.getToken();

  // トークンの確認 このトークンを使って通知を送る
  debugPrint('fcmToken: $fcmToken');

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Androidのプッシュ通知設定
  if (Platform.isAndroid) {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'careapp_channel_id',
        'CareApp Notifications',
        importance: Importance.max,
      ),
    );
    await androidImplementation?.requestNotificationsPermission();
  }

  // 通知設定の初期化を行う
  _initNotification();

  // アプリ停止時に通知をタップした場合はgetInitialMessageでメッセージデータを取得できる
  // final message = await FirebaseMessaging.instance.getInitialMessage();
  // 取得したmessageを利用した処理などを記載する

  // TODO: メッセージの受信
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   debugPrint('Got a message whilst in the foreground!');
  //   if (message.notification != null) {
  //     debugPrint('${message.notification!.title}');
  //     debugPrint('${message.notification!.body}');
  //   }
  // });
}

Future<void> _initNotification() async {
  // https://note.com/shift_tech/n/n97fc26eafc93
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // バックグラウンド起動中に通知をタップした場合の処理
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    // フォアグラウンド起動中に通知が来た場合の処理

    // フォアグラウンド起動中に通知が来た場合、
    // Androidは通知が表示されないため、ローカル通知として表示する
    // https://firebase.flutter.dev/docs/messaging/notifications#application-in-foreground
    if (Platform.isAndroid) {
      // プッシュ通知をローカルから表示する
      await FlutterLocalNotificationsPlugin().show(
        0,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_notification_channel',
            'プッシュ通知のチャンネル名',
            importance: Importance.max, // 通知の重要度の設定
            icon: android?.smallIcon,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  });

  // ローカルから表示したプッシュ通知をタップした場合の処理を設定
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(
          '@mipmap/ic_launcher'), //通知アイコンの設定は適宜行ってください
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        final payloadMap =
            json.decode(details.payload!) as Map<String, dynamic>;
        debugPrint(payloadMap.toString());
      }
    },
  );
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
