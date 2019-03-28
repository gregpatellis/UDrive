import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_drive/globals.dart' as globals;

class crudMethods {

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }


  Future<void> getFname(String uId) async {
    DocumentSnapshot document = await Firestore.instance.collection("Users").document(uId).get();
    globals.fname = document.data['fname'];
  }
  Future<void> getLname(String uId) async {
    DocumentSnapshot document = await Firestore.instance.collection("Users").document(uId).get();
    globals.lname = document.data['lname'];
  }
  Future<void> getAddress(String uId) async {
    DocumentSnapshot document = await Firestore.instance.collection("Users").document(uId).get();
    globals.address = document.data['address'];
  }
  Future<void> getMode(String uId) async {
    DocumentSnapshot document = await Firestore.instance.collection("Users").document(uId).get();
    globals.mode = document.data['mode'];
  }

  Future<void> addData(userData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection("Users").document(globals.get_userID()).setData(userData).catchError((e) {
        print(e);
      });
    }
    else {
      print("User not logged in\n");
    }
  }

  Future<void> addRide(rideData) async {
    //if (isLoggedIn()) {
      Firestore.instance.collection("Rides").add(rideData).catchError((e) {
        print(e);
      });
    //}
  }

  Future<void> addRideCatalog(rideCatalog) async {
    Firestore.instance.collection("RideCatalog").add(rideCatalog).catchError((e) {
      print(e);
    });

  }

  getData() async{
    return await Firestore.instance.collection("Rides").getDocuments();
  }
}