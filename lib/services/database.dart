import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterbook/brew/brew.dart';
import 'package:flutterbook/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection reference - firebase creates the collection for us
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserDate(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars' : sugars,
      'name' :  name,
      'strength' : strength,
    });
  }

  //brewlist form snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Brew(
        name: doc.data['name'] ?? '',
        sugars: doc.data['sugars'] ?? '',
        strength: doc.data['strength'] ?? '',
      );
    }).toList();
  }

  //get brew stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //userdata from snapshots
  UserData _userDataFromSnapshots(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'] ?? '',
      sugars: snapshot.data['sugars'] ?? '',
      strength: snapshot.data['strength'] ?? '',
    );
  }
  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshots);
  }

}

