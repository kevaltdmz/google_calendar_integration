import 'dart:io' show Platform;

class SecretClass {
  static const androidClientId =
      '889303396455-dk3hpegiqs76qsltkpah3j21sbepf6q0.apps.googleusercontent.com';
  static const iosClientId =
      '889303396455-78cqbtd9r08fcb3mvnrln3edro9a49c0.apps.googleusercontent.com';

  static String getId() =>
      Platform.isAndroid ? SecretClass.androidClientId : SecretClass.iosClientId;
}
