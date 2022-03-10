import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseInjectableModule {
  @lazySingleton GoogleSignIn get googleSignIn => GoogleSignIn();
  @lazySingleton FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // @LazySingleton(as: GoogleSignIn) <- This will not work, why?
  // GoogleSignIn get googleSignIn => GoogleSignIn();
  // @LazySingleton(as: FirebaseAuth)
  // FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
