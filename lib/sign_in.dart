import 'dart:convert';

import 'package:demologingg/data/User.dart';
import 'package:demologingg/data/repositories/token.api.services.dart';
import 'package:demologingg/dependency/dependancy_injector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String role;
String token;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

//lay access token firebase
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  TokenApiRepository tokenRepo = new TokenApiRepository();

  UserRepository userRepo = new Injector().userRepository;

  await userRepo.findUserByGmail(email).then((response) {
    Iterable result = json.decode(response.body);
    bool b = result.map((model) => User.fromObject(model)).isEmpty;

    if(b) {
      User userz = new User(email, name, "", "User");
      userRepo.postUser(userz);
    } else {
      role = result.map((model) => User.fromObject(model)).first.role;
    }
  });

  await tokenRepo.fectToken(email).then((response){
    var parseJson = json.decode(response.body); //ma hoa token
    token = parseJson["access_token"];   
    print("Token: " + token.toString());
  });

  return 'LOGIN_OK';
  //return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await _googleSignIn.signOut();
  print("User Sign Out");
}



//Future<FirebaseUser> _handleSignIn() async {
//  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//  final AuthCredential credential = GoogleAuthProvider.getCredential(
//    accessToken: googleAuth.accessToken,
//    idToken: googleAuth.idToken,
//  );
//
//  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
//  print("signed in " + user.displayName);
//  return user;
//
//  final FirebaseUser _user = (await _auth.createUserWithEmailAndPassword(
//    email: 'an email',
//    password: 'a password',
//  ))
//      .user;
//}



//Future<String> signInWithGoogle() async {
//  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//  final GoogleSignInAuthentication googleSignInAuthentication =
//  await googleSignInAccount.authentication;
//
//  final AuthCredential credential = GoogleAuthProvider.getCredential(
//    accessToken: googleSignInAuthentication.accessToken,
//    idToken: googleSignInAuthentication.idToken,
//  );
//
//  final AuthResult authResult = await _auth.signInWithCredential(credential);
//  final FirebaseUser user = authResult.user;
//
//  assert(!user.isAnonymous);
//  assert(await user.getIdToken() != null);
//
//  final FirebaseUser currentUser = await _auth.currentUser();
//  assert(user.uid == currentUser.uid);
//
//  print(currentUser.displayName);
//  print('User email: ' + currentUser.email);
//  return 'signInWithGoogle succeeded: $user';
//}
//
//void signOutGoogle() async{
//  await _googleSignIn.signOut();
//
//  print("User Sign Out");
//}