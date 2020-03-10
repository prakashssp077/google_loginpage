import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  //Email & password signup
  Future<String> createUserWithEmailAndPassword(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );


    //update the username
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    return currentUser.uid;
  }

  //Email & password sign in
  Future<String> signInWithEmailAndPassword(String email, String password) async{
    return(await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    )).uid;
  }
  // sign out
  signOut(){
    return _firebaseAuth.signOut();
  }

  //Google
  Future<String> signInwithGoogle() async{
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken
    );
    return (await _firebaseAuth.signInWithCredential(credential)).uid;
  }
}

class EmailValidator{
  static String validate(String value){
    if(value.isEmpty){
      return " Email can't be empty";
    }
    return null;
  }
}




class NameValidator{
  static String validate(String value){
    if(value.isEmpty){
      return " Name can't be empty";
    }
    if(value.length <3){
      return "Name must be at least 3 characters long";
    }
    return null;
  }
}

class PasswordValidator{
  static String validate(String value){
    if(value.isEmpty){
      return " Password can't be empty";
    }
    return null;
  }
}