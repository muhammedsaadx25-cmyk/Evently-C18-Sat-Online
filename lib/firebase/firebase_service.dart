import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_sat_online/core/resources/constant_manager.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService{
 static Future<UserCredential>register({required String email, required String password})async{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
static Future<UserCredential> login({required String email, required String password})async{
  UserCredential userCredential = await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
 return userCredential;
  }

 static Future<UserCredential?> signInWithGoogle() async {
   try {
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     if (googleUser == null) return null;

     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

     final AuthCredential credential = GoogleAuthProvider.credential(
       accessToken: googleAuth.accessToken,
       idToken: googleAuth.idToken,
     );

     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

     // Check if user exists in Firestore, if not add them
     DocumentSnapshot userDoc = await getUsersCollection().doc(userCredential.user!.uid).get();
     if (!userDoc.exists) {
       UserModel newUser = UserModel(
         id: userCredential.user!.uid,
         name: userCredential.user!.displayName ?? "",
         email: userCredential.user!.email ?? "",
         favouriteEventsIds: [],
       );
       await addUserToFireStore(newUser);
     }

     return userCredential;
   } catch (e) {
     print(e);
     return null;
   }
 }


 static Future<void> logout()async{
   await GoogleSignIn().signOut();
   await  FirebaseAuth.instance.signOut();
  }

  static CollectionReference<UserModel> getUsersCollection(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<UserModel> usersCollection = db.collection(RemoteConstant.userCollection).withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _)=> user.toJson());
    return usersCollection;
  }

  static Future<void>addUserToFireStore(UserModel user){
 //
 //   FirebaseFirestore db = FirebaseFirestore.instance;
 //   CollectionReference<Map<String ,dynamic>> usersCollection =db.collection(RemoteConstant.userCollection);
 //  DocumentReference<Map<String , dynamic>> userDocument =  usersCollection.doc(user.id);
 //
 // return userDocument.set(user.toJson());


    CollectionReference<UserModel> usersCollection = getUsersCollection();

    DocumentReference<UserModel>userDocument =  usersCollection.doc(user.id);
    return userDocument.set(user);


  }
 static Future<UserModel> getUserFromFirStore(String uid)async{
  //  FirebaseFirestore db = FirebaseFirestore.instance;
  //  CollectionReference<Map<String, dynamic>> usersCollection = db.collection(RemoteConstant.userCollection);
  // DocumentReference<Map<String, dynamic>> userDocument =  usersCollection.doc(uid);
  // DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await userDocument.get();
  // Map<String, dynamic> json = documentSnapshot.data()! ;
  // return UserModel.fromJson(json);
CollectionReference<UserModel> usersCollection = getUsersCollection();
   DocumentReference<UserModel> userDocument =  usersCollection.doc(uid);
   DocumentSnapshot<UserModel>  snapshot= await userDocument.get();
   return snapshot.data()!;
 }


static CollectionReference<EventModel> getEventsCollection(BuildContext context){
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<EventModel> eventsCollection =   db.collection(RemoteConstant.eventsCollection).withConverter<EventModel>(
      fromFirestore:(snapshot, _)=> EventModel.fromJson(snapshot.data()!, context) ,
      toFirestore: (event, _)=> event.toJson());
  return eventsCollection;
}
static Future<void>addEventToFireStore(EventModel event, BuildContext context){

 CollectionReference<EventModel> eventsCollection =  getEventsCollection(context);
 DocumentReference<EventModel> eventDocument = eventsCollection.doc();
 event.id = eventDocument.id;
 return eventDocument.set(event);
 }


 static Future<List<EventModel>> getEventsFromFireStore(BuildContext context, [CategoryModel? selectedCategory])async{
   CollectionReference<EventModel> eventsCollection = getEventsCollection(context);
   QuerySnapshot<EventModel> snapshot = await eventsCollection.where("categoryId", isEqualTo: selectedCategory?.id == '0' ? null : selectedCategory?.id).orderBy("dateTime").get();
   List<EventModel> events = snapshot.docs.map((documentSnapshot)=> documentSnapshot.data()).toList();
   // if(selectedCategory.id == '0'){
   //   return events;
   // }else{
   //   List<EventModel> finalEvents = events.where((event)=> event.category!.id == selectedCategory.id).toList();
   //   return finalEvents;
   // }

   return events;

 }



 static Stream<List<EventModel>> getEventsFromFireStoreRealTime(BuildContext context, [CategoryModel? selectedCategory])async*{
   CollectionReference<EventModel> eventsCollection = getEventsCollection(context);
   Stream<QuerySnapshot<EventModel>>   snapshots =  eventsCollection.where("categoryId", isEqualTo: selectedCategory?.id == '0' ? null : selectedCategory?.id).orderBy("dateTime").snapshots();

   Stream<List<EventModel>>events =  snapshots.map((querySnapshot)=>querySnapshot.docs.map((documentSnapshot)=> documentSnapshot.data()).toList());
   // if(selectedCategory.id == '0'){
   //   return events;
   // }else{
   //   List<EventModel> finalEvents = events.where((event)=> event.category!.id == selectedCategory.id).toList();
   //   return finalEvents;
   // }

   yield* events;

 }



 static Future<void> addEventToFavourite(EventModel event){
   UserModel currentUser = UserModel.currentUser!;
   currentUser.favouriteEventsIds.add(event.id!);
  CollectionReference<UserModel> usersCollection =  getUsersCollection();
  DocumentReference<UserModel> userDocument = usersCollection.doc(currentUser.id);

  return userDocument.set(currentUser);
 }

 static Future<void> removeEventFromFavourite(EventModel event){
   UserModel currentUser = UserModel.currentUser!;
   currentUser.favouriteEventsIds.remove(event.id);
   CollectionReference<UserModel> usersCollection = getUsersCollection();
  DocumentReference<UserModel> userDocument = usersCollection.doc(currentUser.id);
  return userDocument.set(currentUser);
 }

 static Future<List<EventModel>> getFavouriteEvents(BuildContext context,)async{
   List<EventModel> events = await getEventsFromFireStore(context);
  List<EventModel> favouriteEvents =  events.where((event)=>UserModel.currentUser!.favouriteEventsIds.contains(event.id)).toList();
  return favouriteEvents;
 }

 static Future<void> deleteEvent(String id, BuildContext context) {
   return getEventsCollection(context).doc(id).delete();
 }

 static Future<void> updateEvent(EventModel event, BuildContext context) {
   return getEventsCollection(context).doc(event.id).set(event);
 }
}



/// omar -> 1
/// mSaad -> 2
/// ahmed-> 3