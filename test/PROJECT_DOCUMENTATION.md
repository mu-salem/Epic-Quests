# 📚 Epic Quests - توثيق المشروع الكامل

## 📑 جدول المحتويات

1. [نظرة عامة على المشروع](#نظرة-عامة)
2. [التقنيات المستخدمة](#التقنيات-المستخدمة)
3. [هيكل المشروع](#هيكل-المشروع)
4. [معمارية MVVM](#معمارية-mvvm)
5. [طبقة الشبكة (Network Layer)](#طبقة-الشبكة)
6. [التخزين المحلي (Hive & SharedPreferences)](#التخزين-المحلي)
7. [إدارة الحالة (Provider)](#إدارة-الحالة-provider)
8. [الـ Features والـ Models](#الـ-features-والـ-models)
9. [استراتيجية Offline-First](#استراتيجية-offline-first)
10. [خدمات التطبيق (Services)](#خدمات-التطبيق)
11. [التوجيه (Routing)](#التوجيه-routing)
12. [تدفق البيانات (Data Flow)](#تدفق-البيانات)

---

## 🎯 نظرة عامة

**Epic Quests** هو تطبيق إنتاجية على شكل لعبة RPG 2D، يحول المهام اليومية إلى مهام (Quests) يكملها البطل (Hero) للحصول على نقاط الخبرة (XP) والترقي في المستويات.

### المميزات الرئيسية:

- ✅ إدارة المهام (Tasks/Quests) بأولويات مختلفة
- 👤 إنشاء أبطال (Heroes) مع أفاتار قابل للتخصيص
- 📊 نظام XP و Leveling
- 🔁 مهام متكررة (Recurring Quests)
- 🍅 Pomodoro Timer للتركيز
- 📅 تقويم لعرض المهام
- 📈 إحصائيات وتتبع الإنجازات
- 🔄 مزامنة أوتوماتيكية مع الخادم
- 📴 دعم كامل للعمل Offline

---

## 🛠️ التقنيات المستخدمة

### الإطار والمكتبات الأساسية:

```yaml
dependencies:
  flutter: sdk

  # UI & Navigation
  flutter_screenutil: ^5.9.3 # Responsive UI
  go_router: ^17.1.0 # Navigation & Deep Linking

  # State Management
  provider: ^6.1.2 # State Management

  # Local Storage
  hive: ^2.2.3 # NoSQL Database
  hive_flutter: ^1.1.0
  shared_preferences: ^2.5.4 # Key-Value Storage
  flutter_secure_storage: ^9.2.2 # Secure Token Storage

  # Networking
  dio: ^5.7.0 # HTTP Client
  pretty_dio_logger: ^1.4.0 # Request Logging
  connectivity_plus: ^6.1.0 # Connectivity Monitoring

  # Media & UI Enhancements
  video_player: ^2.9.2
  audioplayers: ^6.1.0
  flutter_svg: ^2.2.3
  fl_chart: ^0.69.0 # Charts
  table_calendar: ^3.1.2 # Calendar

  # Game Engine
  flame: ^1.24.0 # 2D Game Engine

  # Utilities
  uuid: ^4.5.1 # ID Generation
  intl: ^0.19.0 # Internationalization
  path_provider: ^2.1.5
  vibration: ^2.0.0
```

---

## 📂 هيكل المشروع

المشروع منظم باستخدام **Feature-First Architecture**:

```
lib/
├── main.dart                    # نقطة البداية
├── core/                        # المكونات المشتركة
│   ├── constants/              # الثوابت (API Endpoints, Keys, etc.)
│   ├── models/                 # الموديلات المشتركة (PendingAction)
│   ├── network/                # طبقة الشبكة
│   │   ├── api_client.dart    # Dio Client الرئيسي
│   │   ├── token_manager.dart # إدارة التوكنات
│   │   ├── interceptors/      # Interceptors للمصادقة والتسجيل
│   │   └── error_handling/    # معالجة الأخطاء
│   ├── storage/                # التخزين المحلي
│   │   ├── hive/              # Hive Service
│   │   ├── preferences/       # SharedPreferences Wrapper
│   │   └── secure/            # Secure Storage Wrapper
│   ├── services/               # الخدمات المشتركة
│   │   ├── sync_service.dart
│   │   ├── connectivity_service.dart
│   │   ├── audio_service.dart
│   │   ├── xp_service.dart
│   │   └── recurring_quest_service.dart
│   ├── routing/                # Navigation
│   │   ├── app_router.dart
│   │   └── main_shell.dart
│   ├── theme/                  # Theme & Styling
│   ├── resources/              # Assets (Images, Icons)
│   └── widgets/                # Reusable Widgets
│
└── features/                    # Features منفصلة
    ├── auth/                    # المصادقة (Login, Register)
    │   ├── model/
    │   ├── view/
    │   │   ├── screens/
    │   │   └── widgets/
    │   ├── viewmodel/
    │   └── data/
    │       ├── repositories/
    │       ├── remote/          # API Calls
    │       └── local/           # Local Storage
    │
    ├── tasks/                   # إدارة المهام والأبطال
    │   ├── model/
    │   │   ├── hero_profile.dart
    │   │   ├── quest.dart
    │   │   └── recurring_quest.dart
    │   ├── view/
    │   ├── viewmodel/
    │   │   ├── tasks_viewmodel.dart
    │   │   └── add_quest_viewmodel.dart
    │   └── data/
    │       ├── repositories/
    │       │   ├── hero_profile_repository.dart (Interface)
    │       │   ├── sync_hero_profile_repository.dart
    │       │   ├── quest_repository.dart
    │       │   └── sync_quest_repository.dart
    │       ├── remote/
    │       │   ├── api_hero_profile_repository.dart
    │       │   └── api_quest_repository.dart
    │       └── local/
    │           ├── local_hero_profile_repository.dart
    │           └── local_quest_repository.dart
    │
    ├── recurring/               # المهام المتكررة
    ├── pomodoro/                # مؤقت بومودورو
    ├── stats/                   # الإحصائيات
    ├── calendar/                # التقويم
    ├── profile/                 # الملف الشخصي للبطل
    ├── account/                 # إعدادات الحساب
    └── onboarding/              # الشاشات التعريفية
```

---

## 🏗️ معمارية MVVM

التطبيق يستخدم **MVVM (Model-View-ViewModel)** بشكل صارم مع **Repository Pattern** و **Offline-First Strategy**.

### 📐 الطبقات الأساسية:

```
View (UI)
    ↕️
ViewModel (Business Logic + State)
    ↕️
Repository (Data Abstraction)
    ↕️
Data Sources (Remote API + Local Hive)
```

### 1️⃣ Model

الموديلات تمثل البيانات وتحمل العمليات البسيطة عليها.

**مثال: HeroProfile Model**

```dart
@HiveType(typeId: 0)
class HeroProfile {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String avatarAsset;
  @HiveField(3) final String gender;
  @HiveField(4) final int level;
  @HiveField(5) final int currentXP;
  @HiveField(6) final List<Quest> quests;
  @HiveField(7) final int currentStreak;
  @HiveField(8) final int longestStreak;
  @HiveField(9) final int totalCompletedQuests;
  @HiveField(10) final DateTime createdAt;
  @HiveField(11) final DateTime? lastActivityDate;
  @HiveField(12) final List<RecurringQuest> recurringQuests;

  // Computed properties
  int get maxXP => XPService.calculateMaxXP(level);

  // Business logic methods
  HeroProfile addXP(int xp) { ... }
  HeroProfile removeXP(int xp) { ... }
  HeroProfile recordQuestCompletion() { ... }

  // Serialization
  Map<String, dynamic> toJson() { ... }
  factory HeroProfile.fromJson(Map<String, dynamic> json) { ... }
}
```

**ملاحظات مهمة:**

- ✅ الموديل يحمل الحقول فقط + عمليات بسيطة للحساب
- ✅ يستخدم `Hive Adapters` للتخزين المحلي
- ✅ يوفر `toJson/fromJson` للتعامل مع API
- ✅ يستخدم `copyWith` للتعديلات Immutable

**مثال: Quest Model**

```dart
@HiveType(typeId: 1)
class Quest {
  @HiveField(0) final String id;
  @HiveField(1) final String title;
  @HiveField(2) final String? description;
  @HiveField(3) final DateTime? deadline;
  @HiveField(4) final QuestPriority priority;
  @HiveField(5) final bool isCompleted;
  @HiveField(6) final DateTime? completedAt;
  @HiveField(7) final DateTime createdAt;
  @HiveField(8) final String? recurrenceId;
  @HiveField(9) final int pomodorosCompleted;

  // XP reward based on priority
  int get xpReward {
    switch (priority) {
      case QuestPriority.low: return 10;
      case QuestPriority.medium: return 25;
      case QuestPriority.high: return 50;
    }
  }
}
```

---

### 2️⃣ View

الـ View هي واجهة المستخدم (الشاشات والـ Widgets).

**مثال: TasksHomeScreen**

```dart
class TasksHomeScreen extends StatefulWidget {
  final String? heroName;
  const TasksHomeScreen({super.key, this.heroName});
}

class _TasksHomeScreenState extends State<TasksHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<TasksViewModel>();
      final heroName = widget.heroName ?? await _getLastSelectedHero();

      if (heroName != null) {
        await viewModel.init(heroName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TasksViewModel>(
        builder: (context, viewModel, child) {
          // UI يستمع للتغييرات من ViewModel
          return _buildContent(viewModel);
        },
      ),
    );
  }

  void _handleQuestToggle(String questId) {
    // View تستدعي action في ViewModel
    context.read<TasksViewModel>().toggleQuestCompletion(questId);
  }
}
```

**🔑 مبادئ الـ View:**

- ✅ لا تحمل أي منطق أعمال (Business Logic)
- ✅ تستمع للتغييرات من ViewModel عبر `Consumer` أو `context.watch`
- ✅ تستدعي الـ Actions في ViewModel عبر `context.read`
- ✅ تعرض البيانات فقط

---

### 3️⃣ ViewModel

الـ ViewModel هي طبقة الربط بين View والـ Repository، وتحمل حالة البيانات (State) والمنطق.

**مثال: TasksViewModel**

```dart
class TasksViewModel extends ChangeNotifier {
  // Dependencies (Injected)
  final HeroProfileRepository _repository;
  final QuestRepository _questRepository;

  // State
  String? _currentHeroName;
  HeroProfile? _heroProfile;
  String _searchQuery = '';
  QuestPriority? _selectedPriority;

  // Caching
  List<Quest>? _cachedFilteredActiveQuests;
  List<Quest>? _cachedFilteredCompletedQuests;

  // Constructor with Dependency Injection
  TasksViewModel({
    HeroProfileRepository? repository,
    QuestRepository? questRepository,
  }) : _repository = repository ?? SyncHeroProfileRepository(),
       _questRepository = questRepository ?? SyncQuestRepository();

  // Getters (Expose State to View)
  HeroProfile? get heroProfile => _heroProfile;
  String get heroName => _heroProfile?.name ?? 'Hero';
  int get level => _heroProfile?.level ?? 1;
  int get currentXP => _heroProfile?.currentXP ?? 0;
  List<Quest> get filteredActiveQuests { ... }
  List<Quest> get filteredCompletedQuests { ... }

  // Initialize
  Future<void> init(String heroName) async {
    _currentHeroName = heroName;
    await _loadHeroProfile();
    await _cleanupExpiredQuests();
    await _generateRecurringQuests();
  }

  // Load hero from repository
  Future<void> _loadHeroProfile() async {
    _heroProfile = await _repository.loadHeroProfile(_currentHeroName!);
    _invalidateCache();
    notifyListeners(); // ✅ Notify View to rebuild
  }

  // Toggle quest completion
  Future<void> toggleQuestCompletion(String questId) async {
    if (_heroProfile == null) return;

    final questIndex = _heroProfile!.quests.indexWhere((q) => q.id == questId);
    if (questIndex == -1) return;

    final quest = _heroProfile!.quests[questIndex];
    final updatedQuest = quest.isCompleted
        ? quest.copyWith(isCompleted: false, completedAt: null)
        : quest.copyWith(isCompleted: true, completedAt: DateTime.now());

    // Update XP based on completion
    HeroProfile updatedHero = _heroProfile!;
    if (updatedQuest.isCompleted) {
      updatedHero = updatedHero.addXP(quest.xpReward);
      updatedHero = updatedHero.recordQuestCompletion();
      AudioService().playSuccess();
    } else {
      updatedHero = updatedHero.removeXP(quest.xpReward);
    }

    // Update quests list
    final updatedQuests = List<Quest>.from(updatedHero.quests);
    updatedQuests[questIndex] = updatedQuest;
    updatedHero = updatedHero.copyWith(quests: updatedQuests);

    _heroProfile = updatedHero;
    _invalidateCache();
    await _saveHeroProfile();
    notifyListeners(); // ✅ Notify View
  }

  // Add new quest
  Future<void> addQuest(Quest quest) async {
    final quests = List<Quest>.from(_heroProfile!.quests)..add(quest);
    _heroProfile = _heroProfile!.copyWith(quests: quests);

    _invalidateCache();
    await _saveHeroProfile();
    notifyListeners();
  }

  // Delete quest
  Future<void> deleteQuest(String questId) async {
    final quests = _heroProfile!.quests.where((q) => q.id != questId).toList();
    _heroProfile = _heroProfile!.copyWith(quests: quests);

    _invalidateCache();
    await _saveHeroProfile();
    notifyListeners();
  }
}
```

**🔑 مبادئ الـ ViewModel:**

- ✅ يمتد من `ChangeNotifier` لدعم Provider
- ✅ يستقبل الـ Repositories عبر Constructor Injection
- ✅ يحفظ الـ State الخاص بالشاشة
- ✅ يستدعي `notifyListeners()` بعد أي تغيير في الـ State
- ✅ يتواصل مع Repository فقط (لا يعرف شيئاً عن الـ API أو Hive)

---

### 4️⃣ Repository Pattern

الـ Repository هي **طبقة تجريد** بين ViewModel والـ Data Sources.

**الهيكل:**

```
Repository (Interface)
    ├── SyncRepository (Offline-First Implementation)
    │       ├── LocalRepository (Hive)
    │       └── ApiRepository (Backend API)
```

**مثال: HeroProfileRepository Interface**

```dart
abstract class HeroProfileRepository {
  Future<HeroProfile?> loadHeroProfile(String heroId);
  Future<HeroProfile> saveHeroProfile(HeroProfile profile);
  Future<void> deleteHeroProfile(String heroId);
  Future<bool> hasHeroProfile(String heroId);
  Future<String?> getLastSelectedHero();
  Future<void> setLastSelectedHero(String heroName);
  Future<List<String>> listAllHeroes();
}
```

**مثال: SyncHeroProfileRepository (Offline-First)**

```dart
class SyncHeroProfileRepository implements HeroProfileRepository {
  final LocalHeroProfileRepository _localRepository;
  final ApiHeroProfileRepository _apiRepository;
  final ConnectivityService _connectivityService;
  final SyncService _syncService;

  bool get _isOnline => _connectivityService.isOnline;

  @override
  Future<HeroProfile?> loadHeroProfile(String heroId) async {
    // ✅ Always return from local cache (instant load)
    final localHero = await _localRepository.loadHeroProfile(heroId);

    // If online, sync with API in background
    if (_isOnline) {
      _syncHeroInBackground(heroId);
    }

    return localHero;
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    if (_isOnline) {
      try {
        // Try to sync with API first
        final syncedProfile = await _apiRepository.saveHeroProfile(profile);

        // Save synced data locally
        await _localRepository.saveHeroProfile(syncedProfile);
        return syncedProfile;
      } catch (e) {
        // If API fails, fall back to local save
      }
    }

    // Offline or fallback: save locally and queue for sync
    await _localRepository.saveHeroProfile(profile);
    await _syncService.addPendingAction(
      endpoint: '/heroes/${profile.id}',
      method: 'PUT',
      data: profile.toJson(),
      localId: profile.id,
    );
    return profile;
  }
}
```

**مثال: LocalHeroProfileRepository (Hive)**

```dart
class LocalHeroProfileRepository implements HeroProfileRepository {
  Box<HeroProfile> get _heroBox =>
      HiveService.getTypedBox<HeroProfile>(HiveBoxes.heroProfiles);

  @override
  Future<HeroProfile?> loadHeroProfile(String heroName) async {
    return _heroBox.get(heroName);
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    await _heroBox.put(profile.id, profile);
    return profile;
  }

  @override
  Future<void> deleteHeroProfile(String heroName) async {
    await _heroBox.delete(heroName);
  }
}
```

**مثال: ApiHeroProfileRepository (Backend)**

```dart
class ApiHeroProfileRepository implements HeroProfileRepository {
  final ApiClient _apiClient;

  @override
  Future<HeroProfile?> loadHeroProfile(String heroId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getHero(heroId));
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['hero'] != null) {
        return HeroProfile.fromJson(data['hero']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    final existingHero = await loadHeroProfile(profile.id);

    if (existingHero != null) {
      // Update existing
      final response = await _apiClient.put(
        ApiEndpoints.updateHero(profile.id),
        data: profile.toUpdateJson(),
      );
      return HeroProfile.fromJson(response.data['hero']);
    }

    // Create new
    final response = await _apiClient.post(
      ApiEndpoints.createHero,
      data: profile.toCreateJson(),
    );
    return HeroProfile.fromJson(response.data['hero']);
  }
}
```

---

## 🌐 طبقة الشبكة (Network Layer)

### 1️⃣ ApiClient (Dio Wrapper)

```dart
class ApiClient {
  late final Dio _dio;
  static const String baseUrl = 'https://epic-quests-backend.onrender.com';
  static Function()? onSessionExpired; // Callback للـ logout

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(AppInterceptor());          // Analytics & Logging
    _dio.interceptors.add(AuthInterceptor(...));      // Auto Token Injection
    _dio.interceptors.add(LoggingInterceptor.create()); // Debug Logging
  }

  // GET, POST, PUT, DELETE, PATCH methods with error handling
  Future<Response> get(String path, {...}) async {
    try {
      return await _dio.get(path, ...);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
```

### 2️⃣ AuthInterceptor (Auto Token Management)

```dart
class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Add auth token
    final token = await TokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - Token expired
    if (err.response?.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        final refreshSuccess = await _refreshToken();
        _isRefreshing = false;

        if (refreshSuccess) {
          // Retry original request with new token
          final options = err.requestOptions;
          final newToken = await TokenManager.getAccessToken();
          options.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } else {
          // Refresh failed - logout
          await TokenManager.clearAuthData();
          onSessionExpired?.call();
        }
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenManager.getRefreshToken();
      final response = await dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.data['success'] == true) {
        await TokenManager.saveTokens(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
```

### 3️⃣ API Endpoints

```dart
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';

  // Heroes
  static const String getHeroes = '/heroes';
  static const String createHero = '/heroes';
  static String getHero(String heroId) => '/heroes/$heroId';
  static String updateHero(String heroId) => '/heroes/$heroId';
  static String deleteHero(String heroId) => '/heroes/$heroId';

  // Quests
  static const String getQuests = '/quests';
  static const String createQuest = '/quests';
  static String getQuest(String questId) => '/quests/$questId';
  static String updateQuest(String questId) => '/quests/$questId';
  static String completeQuest(String questId) => '/quests/$questId/complete';

  // Recurring Quests
  static const String recurringQuests = '/recurring-quests';
  static String recurringQuest(String id) => '/recurring-quests/$id';
}
```

---

## 💾 التخزين المحلي (Local Storage)

التطبيق يستخدم **3 أنواع من التخزين**:

### 1️⃣ Hive (NoSQL Database)

**الاستخدام:** تخزين الكائنات المعقدة (Heroes, Quests, Recurring Quests, Pomodoro Sessions)

**التهيئة:**

```dart
class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  static void registerAdapters() {
    Hive.registerAdapter(HeroProfileAdapter());      // TypeId: 0
    Hive.registerAdapter(QuestAdapter());            // TypeId: 1
    Hive.registerAdapter(QuestPriorityAdapter());    // TypeId: 2
    Hive.registerAdapter(PendingActionAdapter());    // TypeId: 3
    Hive.registerAdapter(RecurrenceTypeAdapter());   // TypeId: 5
    Hive.registerAdapter(RecurringQuestAdapter());   // TypeId: 6
    Hive.registerAdapter(PomodoroSessionAdapter());  // TypeId: 7
  }

  static Future<void> openBoxes() async {
    registerAdapters();

    await Hive.openBox<HeroProfile>(HiveBoxes.heroProfiles);
    await Hive.openBox<Quest>(HiveBoxes.quests);
    await Hive.openBox<RecurringQuest>(HiveBoxes.recurringQuests);
    await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
    await Hive.openBox<PomodoroSession>(HiveBoxes.pomodoroSessions);
    await Hive.openBox(HiveBoxes.avatars);
    await Hive.openBox(HiveBoxes.cache);
  }
}
```

**الـ Boxes المستخدمة:**

```dart
class HiveBoxes {
  static const String heroProfiles = 'hero_profiles';
  static const String quests = 'quests';
  static const String recurringQuests = 'recurring_quests';
  static const String pendingActions = 'pending_actions';
  static const String pomodoroSessions = 'pomodoro_sessions';
  static const String avatars = 'avatars';
  static const String cache = 'cache';
}
```

**مثال استخدام:**

```dart
// Save
final box = HiveService.getTypedBox<HeroProfile>(HiveBoxes.heroProfiles);
await box.put(hero.id, hero);

// Read
final hero = box.get(heroId);

// Delete
await box.delete(heroId);

// Get all
final allHeroes = box.values.toList();
```

### 2️⃣ SharedPreferences

**الاستخدام:** تخزين البيانات البسيطة (Strings, Ints, Bools)

```dart
class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }
}
```

**الاستخدامات:**

- ✅ Last selected hero
- ✅ App settings (sound enabled, theme)
- ✅ First launch flag

### 3️⃣ Flutter Secure Storage

**الاستخدام:** تخزين البيانات الحساسة (Tokens)

```dart
class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> readSecure(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }
}
```

**TokenManager:**

```dart
class TokenManager {
  static Future<String?> getAccessToken() async {
    return await SecureStorageService.readSecure(StorageKeys.accessToken);
  }

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await SecureStorageService.writeSecure(
      StorageKeys.accessToken,
      accessToken,
    );
    if (refreshToken != null) {
      await SecureStorageService.writeSecure(
        StorageKeys.refreshToken,
        refreshToken,
      );
    }
  }

  static Future<void> clearAuthData() async {
    await SecureStorageService.deleteSecure(StorageKeys.accessToken);
    await SecureStorageService.deleteSecure(StorageKeys.refreshToken);
  }
}
```

---

## 🔄 إدارة الحالة (Provider)

التطبيق يستخدم **Provider** لإدارة الحالة (State Management).

### التهيئة في main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await LocalStorageService.init();
  await HiveService.initHive();
  await HiveService.openBoxes();

  // Initialize services
  final connectivityService = ConnectivityService();
  await connectivityService.init();

  final syncService = SyncService();
  await syncService.init();

  await AudioService().init();

  final heroRepository = SyncHeroProfileRepository();

  // Setup session expiration callback
  ApiClient.onSessionExpired = () {
    AppRouter.router.go(AppRouter.login);
  };

  runApp(
    MultiProvider(
      providers: [
        // Services (Singleton)
        ChangeNotifierProvider.value(value: connectivityService),
        ChangeNotifierProvider.value(value: syncService),

        // Repositories
        Provider.value(value: heroRepository),

        // ViewModels (Global Scope)
        ChangeNotifierProvider(create: (_) => TasksViewModel()),
        ChangeNotifierProvider(
          create: (_) => RecurringViewModel(
            repository: SyncRecurringQuestRepository(
              ApiRecurringQuestRepository(apiClient: ApiClient()),
            ),
          ),
        ),
      ],
      child: const EpicQuestsApp(),
    ),
  );
}
```

### استخدام Provider في الـ View:

#### 1️⃣ قراءة البيانات والاستماع للتغييرات:

```dart
// Using Consumer (Rebuilds on change)
Consumer<TasksViewModel>(
  builder: (context, viewModel, child) {
    return Text('Level: ${viewModel.level}');
  },
)

// Using context.watch (Rebuilds on change)
final viewModel = context.watch<TasksViewModel>();
return Text('XP: ${viewModel.currentXP}');

// Using Selector (Rebuilds only when selected value changes)
Selector<TasksViewModel, int>(
  selector: (context, vm) => vm.level,
  builder: (context, level, child) {
    return Text('Level: $level');
  },
)
```

#### 2️⃣ استدعاء Actions بدون Rebuild:

```dart
// Using context.read (No rebuild)
onPressed: () {
  context.read<TasksViewModel>().addQuest(newQuest);
}
```

#### 3️⃣ ViewModels خاصة بشاشة معينة:

```dart
// Create ViewModel scoped to a specific screen
ChangeNotifierProvider(
  create: (_) => LoginViewModel(),
  child: LoginScreen(),
)
```

---

## 🎮 الـ Features والـ Models

### 1️⃣ Authentication Feature

**المسؤولية:** تسجيل الدخول، التسجيل، إعادة تعيين كلمة المرور

**ViewModels:**

- `LoginViewModel`
- `RegisterViewModel`
- `ForgotPasswordEmailViewModel`
- `ForgotPasswordCodeViewModel`
- `ResetPasswordViewModel`

**مثال: LoginViewModel**

```dart
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateEmail(String value) {
    _email = value;
    _validateEmail();
    notifyListeners();
  }

  Future<bool> login() async {
    if (!validate()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.login(
        email: _email,
        password: _password,
      );

      if (result['success'] == true) {
        // Save tokens
        await TokenManager.saveTokens(
          accessToken: result['accessToken'],
          refreshToken: result['refreshToken'],
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = result['message'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Network error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

### 2️⃣ Tasks Feature (Core Feature)

**المسؤولية:** إدارة الأبطال والمهام

**Models:**

- `HeroProfile` - بيانات البطل
- `Quest` - المهمة
- `RecurringQuest` - المهمة المتكررة

**ViewModels:**

- `TasksViewModel` - الشاشة الرئيسية
- `AddQuestViewModel` - إضافة/تعديل مهمة

**Repository Pattern:**

```
HeroProfileRepository (Interface)
    └── SyncHeroProfileRepository (Offline-First)
            ├── LocalHeroProfileRepository (Hive)
            └── ApiHeroProfileRepository (Backend)

QuestRepository (Interface)
    └── SyncQuestRepository (Offline-First)
            ├── LocalQuestRepository (Hive)
            └── ApiQuestRepository (Backend)
```

### 3️⃣ Recurring Quests Feature

**المسؤولية:** المهام المتكررة (يومية، أسبوعية، شهرية)

**RecurringQuest Model:**

```dart
@HiveType(typeId: 6)
class RecurringQuest {
  @HiveField(0) final String id;
  @HiveField(1) final String heroId;
  @HiveField(2) final String title;
  @HiveField(3) final String? description;
  @HiveField(4) final QuestPriority priority;
  @HiveField(5) final RecurrenceType recurrence; // daily, weekly, monthly
  @HiveField(6) final bool isActive;
  @HiveField(7) final DateTime? lastGenerated;
  @HiveField(8) final DateTime createdAt;

  // For weekly: which days [0=Mon, 6=Sun]
  @HiveField(9) final List<int> daysOfWeek;

  // For monthly: which day of month (1-31)
  @HiveField(10) final int? dayOfMonth;
}

enum RecurrenceType {
  @HiveField(0) daily,
  @HiveField(1) weekly,
  @HiveField(2) monthly,
}
```

**RecurringQuestService:**

```dart
class RecurringQuestService {
  static Future<HeroProfile> checkAndGenerate(
    HeroProfile hero,
    QuestRepository questRepository,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool generated = false;
    HeroProfile updatedHero = hero;

    for (var recurring in hero.recurringQuests) {
      if (!recurring.isActive) continue;

      // Check if should generate today
      if (_shouldGenerateToday(recurring, today)) {
        // Create new quest instance
        final newQuest = Quest(
          id: uuid.v4(),
          title: recurring.title,
          description: recurring.description,
          priority: recurring.priority,
          recurrenceId: recurring.id,
          createdAt: now,
        );

        // Add quest to hero
        final quests = List<Quest>.from(updatedHero.quests)..add(newQuest);
        updatedHero = updatedHero.copyWith(quests: quests);

        // Update lastGenerated
        final updatedRecurring = recurring.copyWith(lastGenerated: today);
        final recurringList = List<RecurringQuest>.from(updatedHero.recurringQuests);
        final index = recurringList.indexWhere((r) => r.id == recurring.id);
        recurringList[index] = updatedRecurring;
        updatedHero = updatedHero.copyWith(recurringQuests: recurringList);

        generated = true;
      }
    }

    return updatedHero;
  }

  static bool _shouldGenerateToday(RecurringQuest recurring, DateTime today) {
    // Already generated today
    if (recurring.lastGenerated != null) {
      final lastGen = DateTime(
        recurring.lastGenerated!.year,
        recurring.lastGenerated!.month,
        recurring.lastGenerated!.day,
      );
      if (lastGen.isAtSameMomentAs(today)) return false;
    }

    switch (recurring.recurrence) {
      case RecurrenceType.daily:
        return true;

      case RecurrenceType.weekly:
        final weekday = today.weekday - 1; // 0=Mon
        return recurring.daysOfWeek.contains(weekday);

      case RecurrenceType.monthly:
        return today.day == recurring.dayOfMonth;
    }
  }
}
```

### 4️⃣ Pomodoro Feature

**المسؤولية:** مؤقت بومودورو للتركيز

**PomodoroSession Model:**

```dart
@HiveType(typeId: 7)
class PomodoroSession {
  @HiveField(0) final String id;
  @HiveField(1) final String questId;
  @HiveField(2) final DateTime startTime;
  @HiveField(3) final DateTime? endTime;
  @HiveField(4) final int durationMinutes;
  @HiveField(5) final bool completed;
}
```

### 5️⃣ Stats Feature

**المسؤولية:** عرض الإحصائيات والـ Analytics

- إجمالي المهام المكتملة
- الـ Streak الحالي والأقصى
- نسبة الإنجاز حسب الأولوية
- رسوم بيانية للتقدم

### 6️⃣ Calendar Feature

**المسؤولية:** عرض المهام في تقويم

استخدام مكتبة `table_calendar` لعرض المهام حسب التاريخ.

---

## 📴 استراتيجية Offline-First

التطبيق يعمل **Offline-First** بمعنى:

1. ✅ جميع القراءات من Hive (سريعة وتعمل بدون نت)
2. ✅ الكتابات تحدث في Hive أولاً (فورية)
3. ✅ المزامنة مع الـ API تحدث في الخلفية إذا كان هناك نت
4. ✅ إذا فشلت المزامنة، يتم حفظ الـ Action في قائمة انتظار
5. ✅ عند عودة النت، يتم تنفيذ جميع الـ Actions المعلقة

### 1️⃣ ConnectivityService

```dart
class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);

    _connectivity.onConnectivityChanged.listen((results) {
      final wasOnline = _isOnline;
      _isOnline = _isConnected(results);

      if (wasOnline != _isOnline) {
        debugPrint('📡 Connectivity: ${_isOnline ? "ONLINE" : "OFFLINE"}');
        notifyListeners();
      }
    });
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
```

### 2️⃣ SyncService

```dart
class SyncService extends ChangeNotifier {
  bool _isSyncing = false;
  int _pendingActionsCount = 0;

  int get pendingActionsCount => _pendingActionsCount;

  Future<void> init() async {
    _connectivity.addListener(_onConnectivityChanged);
    await _updatePendingCount();

    if (_connectivity.isOnline) {
      await syncPendingActions();
    }
  }

  void _onConnectivityChanged() {
    if (_connectivity.isOnline && !_isSyncing && _pendingActionsCount > 0) {
      syncPendingActions();
    }
  }

  Future<void> addPendingAction({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    String? localId,
  }) async {
    final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
    final action = PendingAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      endpoint: endpoint,
      method: method,
      data: data,
      createdAt: DateTime.now(),
      localId: localId,
    );
    await box.add(action);
    await _updatePendingCount();
    notifyListeners();
  }

  Future<void> syncPendingActions() async {
    if (_isSyncing || _connectivity.isOffline) return;

    _isSyncing = true;
    notifyListeners();

    final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
    final keys = box.keys.toList();

    for (final key in keys) {
      final action = box.get(key);
      if (action == null) continue;

      try {
        await _executeAction(action);
        await box.delete(key); // Remove if successful
      } catch (e) {
        // Retry logic
        final updatedAction = action.copyWith(
          retryCount: action.retryCount + 1,
        );
        if (updatedAction.retryCount >= 3) {
          await box.delete(key); // Remove after 3 retries
        } else {
          await box.put(key, updatedAction);
        }
      }
    }

    await _updatePendingCount();
    _isSyncing = false;
    notifyListeners();
  }

  Future<void> _executeAction(PendingAction action) async {
    switch (action.method.toUpperCase()) {
      case 'POST':
        await _apiClient.post(action.endpoint, data: action.data);
        break;
      case 'PUT':
        await _apiClient.put(action.endpoint, data: action.data);
        break;
      case 'DELETE':
        await _apiClient.delete(action.endpoint);
        break;
    }
  }
}
```

### 3️⃣ PendingAction Model

```dart
@HiveType(typeId: 3)
class PendingAction {
  @HiveField(0) final String id;
  @HiveField(1) final String endpoint;
  @HiveField(2) final String method; // POST, PUT, DELETE
  @HiveField(3) final Map<String, dynamic>? data;
  @HiveField(4) final DateTime createdAt;
  @HiveField(5) final int retryCount;
  @HiveField(6) final String? localId; // For ID reassignment after sync
}
```

---

## 🎯 خدمات التطبيق (Services)

### 1️⃣ XPService

```dart
class XPService {
  static int calculateXPGain(QuestPriority priority) {
    switch (priority) {
      case QuestPriority.low: return 10;
      case QuestPriority.medium: return 25;
      case QuestPriority.high: return 50;
    }
  }

  static int calculateMaxXP(int level) {
    return 100 + (level - 1) * 50; // 100, 150, 200, 250, ...
  }

  static Map<String, int> addXP({
    required int currentLevel,
    required int currentXP,
    required int xpToAdd,
  }) {
    int level = currentLevel;
    int xp = currentXP + xpToAdd;

    while (xp >= calculateMaxXP(level)) {
      xp -= calculateMaxXP(level);
      level++;
    }

    return {'level': level, 'currentXP': xp};
  }

  static Map<String, int> removeXP({
    required int currentLevel,
    required int currentXP,
    required int xpToRemove,
  }) {
    int level = currentLevel;
    int xp = currentXP - xpToRemove;

    while (xp < 0 && level > 1) {
      level--;
      xp += calculateMaxXP(level);
    }

    if (xp < 0) xp = 0;
    return {'level': level, 'currentXP': xp};
  }
}
```

### 2️⃣ QuestCleanupService

```dart
class QuestCleanupService {
  static const int daysToKeepCompleted = 7; // Keep completed quests for 7 days

  static List<Quest> removeExpiredQuests(List<Quest> quests) {
    final cutoffDate = DateTime.now().subtract(
      Duration(days: daysToKeepCompleted),
    );

    return quests.where((quest) {
      if (!quest.isCompleted) return true; // Keep active quests
      if (quest.completedAt == null) return true;

      return quest.completedAt!.isAfter(cutoffDate);
    }).toList();
  }
}
```

### 3️⃣ AudioService

```dart
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;

  Future<void> init() async {
    _soundEnabled = LocalStorageService.getBool('sound_enabled') ?? true;
  }

  Future<void> playSuccess() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('audio/sfx/success.mp3'));
  }

  Future<void> playLevelUp() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('audio/sfx/level_up.mp3'));
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    LocalStorageService.setBool('sound_enabled', _soundEnabled);
  }
}
```

---

## 🗺️ التوجيه (Routing)

التطبيق يستخدم **GoRouter** للتوجيه و Deep Linking.

### AppRouter:

```dart
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String stats = '/stats';
  static const String calendar = '/calendar';
  static const String questDetails = '/quest/:id';
  static const String pomodoro = '/pomodoro';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Main Shell with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) {
                  final heroName = state.uri.queryParameters['heroName'];
                  return TasksHomeScreen(heroName: heroName);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: stats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: calendar,
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
```

### MainShell (Bottom Navigation):

```dart
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
```

---

## 🔄 تدفق البيانات (Data Flow)

### مثال كامل: إضافة Quest جديدة

#### 1️⃣ User يضغط على زر "Add Quest" في View:

```dart
// tasks_home_screen.dart
FloatingActionButton(
  onPressed: () {
    QuestModalHelper.showAddQuestModal(
      context: context,
      viewModel: context.read<TasksViewModel>(),
    );
  },
)
```

#### 2️⃣ Modal يظهر مع AddQuestViewModel:

```dart
// add_quest_modal.dart
showModalBottomSheet(
  context: context,
  builder: (modalContext) {
    return ChangeNotifierProvider(
      create: (_) => AddQuestViewModel(),
      child: AddQuestModal(
        onSave: (quest) async {
          await viewModel.addQuest(quest);
          Navigator.pop(modalContext);
        },
      ),
    );
  },
);
```

#### 3️⃣ User يملأ البيانات ويحفظ:

```dart
// AddQuestViewModel
class AddQuestViewModel extends ChangeNotifier {
  String _title = '';
  QuestPriority _priority = QuestPriority.medium;

  void updateTitle(String value) {
    _title = value;
    notifyListeners();
  }

  Quest createQuest() {
    return Quest(
      id: uuid.v4(),
      title: _title,
      priority: _priority,
      createdAt: DateTime.now(),
    );
  }
}
```

#### 4️⃣ Quest يتم إرساله إلى TasksViewModel:

```dart
// TasksViewModel
Future<void> addQuest(Quest quest) async {
  final quests = List<Quest>.from(_heroProfile!.quests)..add(quest);
  _heroProfile = _heroProfile!.copyWith(quests: quests);

  _invalidateCache();
  await _saveHeroProfile(); // ➡️ يستدعي Repository
  notifyListeners();        // ➡️ يحدث الـ UI
}
```

#### 5️⃣ Repository يحفظ في Hive و يزامن مع API:

```dart
// SyncHeroProfileRepository
Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
  if (_isOnline) {
    try {
      // ✅ Sync with API first
      final syncedProfile = await _apiRepository.saveHeroProfile(profile);

      // ✅ Save synced data locally
      await _localRepository.saveHeroProfile(syncedProfile);
      return syncedProfile;
    } catch (e) {
      // If API fails, fall back to local
    }
  }

  // ✅ Save locally
  await _localRepository.saveHeroProfile(profile);

  // ✅ Queue for later sync
  await _syncService.addPendingAction(
    endpoint: '/heroes/${profile.id}',
    method: 'PUT',
    data: profile.toJson(),
  );

  return profile;
}
```

#### 6️⃣ Local Repository يحفظ في Hive:

```dart
// LocalHeroProfileRepository
Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
  await _heroBox.put(profile.id, profile);
  return profile;
}
```

#### 7️⃣ API Repository يرسل إلى الخادم:

```dart
// ApiHeroProfileRepository
Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
  final response = await _apiClient.put(
    ApiEndpoints.updateHero(profile.id),
    data: profile.toUpdateJson(),
  );
  return HeroProfile.fromJson(response.data['hero']);
}
```

#### 8️⃣ ApiClient يرسل الطلب عبر Dio:

```dart
// ApiClient
Future<Response> put(String path, {dynamic data}) async {
  try {
    return await _dio.put(path, data: data);
  } on DioException catch (e) {
    throw ErrorHandler.handleDioError(e);
  }
}
```

#### 9️⃣ AuthInterceptor يضيف التوكن تلقائياً:

```dart
// AuthInterceptor
@override
Future<void> onRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  final token = await TokenManager.getAccessToken();
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  handler.next(options);
}
```

#### 🔟 إذا كان الجهاز Offline:

```dart
// SyncService
await addPendingAction(
  endpoint: '/heroes/${profile.id}',
  method: 'PUT',
  data: profile.toJson(),
  localId: profile.id,
);

// عند عودة النت:
await syncPendingActions(); // ✅ يرسل جميع الـ Actions المعلقة
```

---

## 📊 ملخص الربط بين المكونات

### Endpoints ↔️ ApiClient ↔️ Repository ↔️ ViewModel ↔️ View

```
┌──────────────────────────────────────────────────────────────┐
│                         VIEW (UI)                            │
│  - TasksHomeScreen                                           │
│  - Uses Consumer<TasksViewModel>                             │
│  - Calls viewModel.addQuest(quest)                           │
└───────────────────────┬──────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│                   VIEWMODEL (State)                          │
│  - TasksViewModel extends ChangeNotifier                     │
│  - Holds _heroProfile state                                  │
│  - Calls _repository.saveHeroProfile()                       │
│  - Calls notifyListeners()                                   │
└───────────────────────┬──────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│              REPOSITORY (Offline-First Logic)                │
│  - SyncHeroProfileRepository                                 │
│  - Checks connectivity                                       │
│  - Saves to LocalRepository (Hive)                           │
│  - Syncs with ApiRepository (Backend)                        │
│  - Queues failed actions in SyncService                      │
└─────────────┬────────────────────────┬───────────────────────┘
              │                        │
              ▼                        ▼
┌─────────────────────────┐  ┌────────────────────────────────┐
│  LOCAL REPOSITORY       │  │    API REPOSITORY              │
│  - Hive Storage         │  │    - ApiClient (Dio)           │
│  - Instant Save/Load    │  │    - Endpoints                 │
│  - Works Offline        │  │    - AuthInterceptor           │
└─────────────────────────┘  └────────────────────────────────┘
```

### Hive ↔️ Provider ↔️ Endpoints

```
[Hive Boxes]
    ↕️
[LocalRepository]
    ↕️
[SyncRepository] ←→ [ApiRepository] ←→ [ApiClient] ←→ [Backend]
    ↕️
[ViewModel (ChangeNotifier)]
    ↕️
[Provider]
    ↕️
[View (Consumer/watch/read)]
```

---

## ✅ الخلاصة

### المعمارية:

- ✅ **MVVM Pattern** بشكل صارم
- ✅ **Repository Pattern** لفصل مصادر البيانات
- ✅ **Dependency Injection** عبر الـ Constructors
- ✅ **Offline-First Strategy** مع مزامنة تلقائية

### التقنيات:

- ✅ **Provider** لإدارة الحالة
- ✅ **Hive** للتخزين المحلي السريع
- ✅ **Dio** للشبكة مع Interceptors
- ✅ **GoRouter** للتوجيه
- ✅ **Secure Storage** للتوكنات

### الـ Data Flow:

1. **View** تستدعي action في **ViewModel**
2. **ViewModel** تستدعي **Repository**
3. **Repository** تحفظ في **Hive** (سريع)
4. **Repository** تزامن مع **API** (في الخلفية)
5. إذا فشل API، يتم حفظ الـ action في **SyncService**
6. عند عودة النت، **SyncService** ترسل جميع الـ actions المعلقة

### المميزات:

- ✅ يعمل بدون نت (Offline-First)
- ✅ مزامنة تلقائية عند عودة النت
- ✅ إدارة التوكنات أوتوماتيكية مع Token Refresh
- ✅ معالجة الأخطاء على جميع المستويات
- ✅ كود منظم وقابل للصيانة
- ✅ يعلم المستخدم بحالة عدم الاتصال بشكل غير مزعج
- ✅ يحافظ على بيانات المستخدمين آمنة محلياً حتى تعود الشبكة

---

## ⚡ تحسينات الأداء (Optimistic UI)

تمت ترقية التطبيق ليعتمد على نمط **Optimistic UI Updates** لجعل تجربة المستخدم أسرع ولحظية، دون انتظار استجابة الخادم.

### المشكلة السابقة:

في الإصدارات الأولى، كانت الـ ViewModels (مثل `TasksViewModel` أو `RecurringViewModel`) تقوم بتجميد الواجهة (يتم عمل `await`) حتى يكتمل الاتصال بالـ Backend:

```dart
// ❌ النمط القديم (بطيء)
await _repository.saveQuest(quest); // ينتظر الـ API والإنترنت
notifyListeners(); // يتحدث الـ UI بعد ثواني
```

### الحل (Optimistic UI):

تم فصل تحديث الواجهة عن عملية المزامنة مع الخادم. الآن، التطبيق يقوم بتحديث البيانات محلياً **فوراً**، ثم يرسل الطلب للخادم في الخلفية (Background):

```dart
// ✅ النمط الجديد (فوري)
// 1. التحديث المحلي الفوري
_quests.add(quest);
notifyListeners(); // الواجهة تتحدث في نفس اللحظة

// 2. المزامنة في الخلفية (بدون await)
_repository.saveQuest(quest).then((syncedQuest) {
  // تحديث الـ IDs أو البيانات إذا لزم الأمر بصمت
}).catchError((e) {
  // معالجة الخطأ
});
```

### أين تم تطبيق هذا النمط؟

- **إضافة مهمة جديدة** (`TasksViewModel.addQuest` و `RecurringViewModel.saveQuest`): تظهر المهمة في القائمة فوراً.
- **إكمال وظيفة / مهمة** (`TasksViewModel.toggleQuestCompletion`): يتحول حالة المهمة لـ Completed فوراً ويسمع صوت الـ Success مع إضافة الـ XP.
- **حذف مهمة** (`TasksViewModel.deleteQuest` و `RecurringViewModel.deleteQuest`): تختفي المهمة فوراً من الواجهة.
- **تحديث الخصائص**: كلاً من العادي والمتكرر (`TasksViewModel.updateQuest` و `RecurringViewModel.toggleActive`) يتحدثان فوراً بدون انتظار.
- **الاستغناء عن التنقل التلقائي**: تم إزالة النقل التلقائي لتبويبة "المكتملة" (Completed Tab) بعد إنهاء مهمة، لترك الحرية للمستخدم في البقاء في التبويبة التي يريدها (`TasksHomeScreen._handleQuestToggle`).

هذا النهج جعل استجابة التطبيق تبدو وكأنها Offline 100%، مما وفر تجربة خيالية للمستخدم (Snappy Experience).

---

**تم إنشاء هذا التوثيق بواسطة GitHub Copilot 🚀**

**التاريخ:** فبراير 26, 2026
