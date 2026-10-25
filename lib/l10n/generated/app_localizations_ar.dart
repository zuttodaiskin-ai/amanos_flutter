// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أمانوس';

  @override
  String get userDirectory => 'دليل المستخدمين';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'eve.holt@reqres.in';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get users => 'المستخدمون';

  @override
  String get refresh => 'تحديث';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get loginOfflineHint =>
      'يلزم الإنترنت عند أول تسجيل دخول. بعد تحميل البيانات يمكنك عرض الصفحات المحفوظة دون إنترنت.';

  @override
  String get useDemoAccount => 'استخدام بيانات الحساب التجريبي';

  @override
  String get logoutFailed => 'تعذر تسجيل الخروج. حاول مجددًا.';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noUsers => 'لا يوجد مستخدمون';

  @override
  String get cachedData =>
      'تعذر الاتصال — يتم عرض البيانات المحفوظة على الجهاز.';

  @override
  String get cacheWriteFailed =>
      'تم تحميل البيانات لكن تعذر حفظها للاستخدام دون إنترنت.';

  @override
  String totalUsers(int count) {
    return 'إجمالي المستخدمين: $count';
  }

  @override
  String pageIndicator(int page, int totalPages) {
    return '$page / $totalPages';
  }

  @override
  String get userDetails => 'تفاصيل المستخدم';

  @override
  String userId(int id) {
    return 'رقم المستخدم: $id';
  }

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get languageSaveFailed => 'تعذر حفظ اللغة. حاول مجددًا.';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get checkingSession => 'جارٍ استعادة الجلسة…';

  @override
  String get connectionFailed => 'تعذر الاتصال. تحقق من الإنترنت وحاول مجددًا.';

  @override
  String get requestForbidden =>
      'رفضت الخدمة الطلب. تحقق من مفتاح ReqRes وحدود استخدامه.';

  @override
  String get rateLimited => 'تم تجاوز حد الطلبات. حاول لاحقًا.';

  @override
  String get unauthorized => 'فشلت المصادقة. تحقق من بيانات الدخول ومفتاح API.';

  @override
  String get requestFailed => 'تعذر إتمام الطلب. حاول مجددًا.';

  @override
  String get userNotFound => 'المستخدم غير موجود. تحقق من بيانات الدخول.';

  @override
  String get missingEmail => 'الرجاء إدخال البريد الإلكتروني.';

  @override
  String get missingPassword => 'الرجاء إدخال كلمة المرور.';

  @override
  String get invalidLoginResponse => 'استجابة تسجيل الدخول غير صالحة.';

  @override
  String get cacheReadFailed =>
      'تعذر قراءة البيانات المحفوظة. اتصل بالإنترنت لتحديثها.';

  @override
  String get uncachedPage =>
      'لا يوجد اتصال وهذه الصفحة غير محفوظة. حمّلها عند توفر الإنترنت.';

  @override
  String get sessionReadFailed => 'تعذر قراءة جلسة الدخول المحفوظة.';

  @override
  String get credentialsRequired =>
      'الرجاء إدخال البريد الإلكتروني وكلمة المرور.';

  @override
  String get invalidEmail => 'الرجاء إدخال بريد إلكتروني صالح.';
}
