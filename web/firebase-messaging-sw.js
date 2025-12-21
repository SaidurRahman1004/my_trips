importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "আপনার_API_KEY_দিন",
  authDomain: "আপনার_PROJECT_ID.firebaseapp.com",
  projectId: "আপনার_PROJECT_ID",
  storageBucket: "আপনার_PROJECT_ID.appspot.com",
  messagingSenderId: "আপনার_SENDER_ID",
  appId: "আপনার_APP_ID",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log(
    "[firebase-messaging-sw.js] Received background message ",
    payload
  );
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/icons/icon-192.png", // আপনার আইকনের পাথ
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
