importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDFlXrjaQ25wdZiSnRl4hVBuPjzPjlQPew",
  authDomain: "flutterapp-60eb7.firebaseapp.com",
  projectId: "flutterapp-60eb7",
  storageBucket: "flutterapp-60eb7.appspot.com",
  messagingSenderId: "56789513515",
  appId: "1:356789513515:web:6ac4bc4355a766d13c696e",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// TODO: バックグランドでのメッセージ受信処理
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});