import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  // hasEnrolledBiometrics() determines if Bio-metric login button
  // should be shown to a user or not

  // Hence, Bio-metric login button is displayed
  // if user has some enrolled biometrics on his device
  Future<bool> hasEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
    await _auth.getAvailableBiometrics(); //returns the list of enrolled
    // bio-metrics of particular device

    if (availableBiometrics.isNotEmpty) {
      return true;
    }
    return false;
  }

  // The function returns true if authentication is successful
  Future<bool> authenticate() async {
    final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  }
}