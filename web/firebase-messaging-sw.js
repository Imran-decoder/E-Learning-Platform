//// [firebase-messaging-sw.js] - Firebase Messaging Service Worker
//
//import("https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js");
//import("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging.js");
//
//// Firebase configuration
//const firebaseConfig = {
//  apiKey: "AIzaSyAP3EJsdhfX8KRixz2x-vUyQQjdf969OrQ",
//  authDomain: "elearning-8a3f4.firebaseapp.com",
//  projectId: "elearning-8a3f4",
//  storageBucket: "elearning-8a3f4.appspot.com",
//  messagingSenderId: "209667955295",
//  appId: "1:209667955295:web:1977a9d709921ac0f319ea"
//};
//
//// Initialize Firebase
////const app = initializeApp(firebaseConfig);
//firebase.initializeApp(firebaseConfig);
//const messaging = firebase.messaging();
//
//// Handle background messages
//messaging.onBackgroundMessage((payload) => {
//  console.log("[firebase-messaging-sw.js] Received background message:", payload);
//
//  const notificationTitle = payload.notification.title;
//  const notificationOptions = {
//    body: payload.notification.body,
//    icon: "/icons/Icon-192.png"
//  };
//
//  self.registration.showNotification(notificationTitle, notificationOptions);
//});


