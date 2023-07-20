import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

late final Map<String, String> signInHeaders;

String accessToken = '';

class AuthService {
  // Sign in with google
  Future<User?> signInWithGoogleRequested() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: [CalendarApi.calendarScope]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    signInHeaders = await googleUser.authHeaders;

    accessToken = googleAuth.accessToken!;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final response =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return response.user;
  }
}
