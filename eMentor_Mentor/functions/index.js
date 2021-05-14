
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// exports.myFunction = functions.firestore
//     .document('users/{userId}')
//     .onWrite((change, context) => {
//         // const document = change.after.exists ? change.after.data() : null;
//         const oldDocument = change.before.data();
//         console.log(oldDocument);
//         return admin.messaging().sendToTopic('users', {
//             notification: {
//                 title: oldDocument.displayname,
//                 body: oldDocument.email,
//                 clickAction: 'FLUTTER_NOTIFICATION_CLICK',
//             },
//         });
//     });



