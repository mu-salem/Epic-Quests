/// App Images Resources
/// 
/// Centralized image asset paths for the application
class AppImages {
  AppImages._();

  // Base paths
  static const String _basePath = 'assets/images';
  static const String _avatarPath = '$_basePath/avatar';
  static const String _doorPath = '$_basePath/door';

  // Door Images (Splash Screen)
  static const String doorFrame = '$_doorPath/door_frame.png';
  static const String doorLeft = '$_doorPath/door_left.png';
  static const String doorRight = '$_doorPath/door_right.png';

  // Avatar Cover/Background
  static const String avatarCoverPage = '$_avatarPath/avatar_cover_page.png';

  // Boy Avatars
  static const String avatarArin = '$_avatarPath/Arin.png';
  static const String avatarLeo = '$_avatarPath/Leo.png';
  static const String avatarJax = '$_avatarPath/Jax.png';
  static const String avatarKane = '$_avatarPath/Kane.png';
  static const String avatarLynx = '$_avatarPath/Lynx.png';
  static const String avatarCedric = '$_avatarPath/Cedric.png';
  static const String avatarRagnar = '$_avatarPath/Ragnar.png';
  static const String avatarOrion = '$_avatarPath/Orion.png';

  // Girl Avatars
  static const String avatarLuna = '$_avatarPath/Luna.png';
  static const String avatarKira = '$_avatarPath/Kira.png';
  static const String avatarElara = '$_avatarPath/Elara.png';
  static const String avatarVexa = '$_avatarPath/Vexa.png';
  static const String avatarSeraphina = '$_avatarPath/Seraphina.png';
  static const String avatarKaela = '$_avatarPath/Kaela.png';
  static const String avatarSylvi = '$_avatarPath/Sylvi.png';
  static const String avatarNyra = '$_avatarPath/Nyra.png';

  // Other Images
  static const String map = '$_basePath/Map.png';

  // Default avatar (fallback)
  static const String defaultAvatar = avatarArin;
}
