import '../../../core/resources/app_images.dart';
import 'avatar_item.dart';

/// Available avatar templates for boys
class AvatarTemplates {
  AvatarTemplates._(); // Private constructor to prevent instantiation

  /// All boy character templates
  static const List<AvatarTemplate> boys = [
    AvatarTemplate(name: 'Arin', asset: AppImages.avatarArin, gender: 'boy'),
    AvatarTemplate(name: 'Leo', asset: AppImages.avatarLeo, gender: 'boy'),
    AvatarTemplate(name: 'Jax', asset: AppImages.avatarJax, gender: 'boy'),
    AvatarTemplate(name: 'Kane', asset: AppImages.avatarKane, gender: 'boy'),
    AvatarTemplate(name: 'Lynx', asset: AppImages.avatarLynx, gender: 'boy'),
    AvatarTemplate(name: 'Cedric', asset: AppImages.avatarCedric, gender: 'boy'),
    AvatarTemplate(name: 'Ragnar', asset: AppImages.avatarRagnar, gender: 'boy'),
    AvatarTemplate(name: 'Orion', asset: AppImages.avatarOrion, gender: 'boy'),
  ];

  /// All girl character templates
  static const List<AvatarTemplate> girls = [
    AvatarTemplate(name: 'Luna', asset: AppImages.avatarLuna, gender: 'girl'),
    AvatarTemplate(name: 'Kira', asset: AppImages.avatarKira, gender: 'girl'),
    AvatarTemplate(name: 'Elara', asset: AppImages.avatarElara, gender: 'girl'),
    AvatarTemplate(name: 'Vexa', asset: AppImages.avatarVexa, gender: 'girl'),
    AvatarTemplate(name: 'Seraphina', asset: AppImages.avatarSeraphina, gender: 'girl'),
    AvatarTemplate(name: 'Kaela', asset: AppImages.avatarKaela, gender: 'girl'),
    AvatarTemplate(name: 'Sylvi', asset: AppImages.avatarSylvi, gender: 'girl'),
    AvatarTemplate(name: 'Nyra', asset: AppImages.avatarNyra, gender: 'girl'),
  ];

  /// Get all templates
  static List<AvatarTemplate> get all => [...boys, ...girls];

  /// Get templates by gender
  static List<AvatarTemplate> byGender(String gender) {
    return gender == 'boy' ? boys : girls;
  }
}
