# CareLink 💊

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success)
![State](https://img.shields.io/badge/State-BLoC-purple)
![Router](https://img.shields.io/badge/Router-GoRouter-orange)
![CI](https://img.shields.io/github/actions/workflow/status/abdelfattahhussam/carelink/ci.yml?label=CI)
![Tests](https://img.shields.io/badge/Tests-78%20passing-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## English Section

### About
CareLink is a Flutter mobile application that bridges medicine donors, patients, and pharmacists. Donors contribute unexpired medicines, patients request what they need, and pharmacists act as trusted intermediaries — verifying donations, approving requests, and confirming handovers via a secure QR workflow.

### Features

| Feature | Description |
|---|---|
| Role-based access | User (donate + request) and Pharmacist roles with granular permissions |
| Medicine donation | Donors submit medicines with expiry dates, photos, and pharmacy selection |
| Medicine requests | Users browse available medicines and submit requests with prescriptions |
| QR handover | Pharmacist scans QR to confirm physical pickup — mutual verification |
| Pharmacy location | Filter donations and medicines by governorate, city, and district |
| Notifications | Real-time status updates for approvals, rejections, and expiry warnings |
| Bilingual | Full Arabic (RTL) and English (LTR) support |
| Dark mode | Complete light and dark theme with Material 3 |

### Architecture

```text
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  Screens · BLoCs · Widgets · RBAC  │
├─────────────────────────────────────┤
│           Domain Layer              │
│   Repository Interfaces (7 files)  │
├─────────────────────────────────────┤
│            Data Layer               │
│  Services · Models · MockInterceptor│
├─────────────────────────────────────┤
│             Core Layer              │
│  Router · Theme · DI · Auth Storage│
└─────────────────────────────────────┘
```

### Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Stable channel) |
| Language | Dart 3.x |
| State Management | flutter_bloc — BLoC pattern |
| Navigation | go_router with RBAC guards |
| Networking | dio with MockInterceptor |
| Auth Storage | flutter_secure_storage |
| UI | Material 3 + Google Fonts (Inter) |
| Localization | flutter_intl — ARB files |
| Testing | bloc_test + mocktail (78 tests) |
| CI/CD | GitHub Actions |

### Roles & Permissions

| Permission | User | Pharmacist |
|---|---|---|
| Donate medicine | ✅ | ❌ |
| Request medicine | ✅ | ❌ |
| View own donations | ✅ | ❌ |
| View own requests | ✅ | ❌ |
| Review donations | ❌ | ✅ |
| Manage requests | ❌ | ✅ |
| Scan QR | ❌ | ✅ |
| View dashboard | ❌ | ✅ |

### Getting Started

```bash
# Clone
git clone https://github.com/abdelfattahhussam/carelink.git
cd carelink

# Install dependencies
flutter pub get

# Run with mock backend (no real API needed)
flutter run --dart-define=USE_MOCK=true

# Run tests
flutter test

# Analyze
flutter analyze
```

### Project Structure

Please refer to the [tree.txt](tree.txt) file in the root of the repository for the full project structure.

### Test Accounts

| Role | Email | Password |
|---|---|---|
| User | user@test.com | any value |
| Pharmacist | pharmacist@test.com | any value |

### Screenshots

> Screenshots coming soon — the app runs on Android and iOS.
> To capture: `flutter run --dart-define=USE_MOCK=true` on a device or emulator.

### Roadmap

#### Backend Integration (next)
- [ ] Connect REST API (replace MockInterceptor)
- [ ] JWT authentication with refresh tokens
- [ ] Real pagination

#### Future Features
- [ ] Push notifications (FCM)
- [ ] Image upload to cloud storage
- [ ] Pharmacist multi-branch support
- [ ] Audit log screen

---

## Arabic Section (العربية)

### نبذة عن المشروع
تطبيق CareLink هو تطبيق للهواتف المحمولة مبني باستخدام Flutter، ويهدف إلى الربط بين المتبرعين بالأدوية، والمرضى، والصيادلة. يساهم المتبرعون بالأدوية غير المنتهية الصلاحية، ويقوم المرضى بطلب ما يحتاجونه، بينما يعمل الصيادلة كوسطاء موثوقين — حيث يقومون بالتحقق من التبرعات، والموافقة على الطلبات، وتأكيد عمليات التسليم من خلال سير عمل آمن يعتمد على رمز الاستجابة السريعة (QR).

### المميزات

| الميزة | الوصف |
|---|---|
| التحكم في الصلاحيات | أدوار للمستخدم (تبرع + طلب) والصيدلي مع صلاحيات دقيقة |
| التبرع بالدواء | تقديم الأدوية مع تواريخ الصلاحية، والصور، واختيار الصيدلية |
| طلب الدواء | تصفح الأدوية المتاحة وتقديم الطلبات مع الوصفات الطبية |
| التسليم عبر QR | يقوم الصيدلي بمسح رمز QR لتأكيد الاستلام الفعلي — تحقق متبادل |
| موقع الصيدلية | تصفية التبرعات والأدوية حسب المحافظة، والمدينة، والحي |
| الإشعارات | تحديثات حالة فورية للموافقات، والرفض، وتحذيرات انتهاء الصلاحية |
| ثنائي اللغة | دعم كامل للغتين العربية (من اليمين لليسار) والإنجليزية (من اليسار لليمين) |
| الوضع الداكن | مظهر فاتح وداكن متكامل باستخدام Material 3 |

### المعمارية (المعمارية النظيفة)

```text
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  Screens · BLoCs · Widgets · RBAC  │
├─────────────────────────────────────┤
│           Domain Layer              │
│   Repository Interfaces (7 files)  │
├─────────────────────────────────────┤
│            Data Layer               │
│  Services · Models · MockInterceptor│
├─────────────────────────────────────┤
│             Core Layer              │
│  Router · Theme · DI · Auth Storage│
└─────────────────────────────────────┘
```

### التقنيات المستخدمة

| الفئة | التقنية |
|---|---|
| إطار العمل | Flutter (Stable channel) |
| لغة البرمجة | Dart 3.x |
| إدارة الحالة | flutter_bloc — نمط BLoC |
| التنقل | go_router مع حراس RBAC |
| الشبكات | dio مع واجهة خلفية محاكاة (MockInterceptor) |
| تخزين المصادقة | flutter_secure_storage |
| واجهة المستخدم | Material 3 + خطوط جوجل (Inter) |
| الترجمة | flutter_intl — ملفات ARB |
| الاختبار | bloc_test + mocktail (78 اختباراً) |
| التكامل المستمر | GitHub Actions |

### الأدوار والصلاحيات

| الصلاحية | مستخدم | صيدلي |
|---|---|---|
| التبرع بالدواء | ✅ | ❌ |
| طلب الدواء | ✅ | ❌ |
| عرض تبرعاتي | ✅ | ❌ |
| عرض طلباتي | ✅ | ❌ |
| مراجعة التبرعات | ❌ | ✅ |
| إدارة الطلبات | ❌ | ✅ |
| مسح رمز QR | ❌ | ✅ |
| عرض لوحة التحكم | ❌ | ✅ |

### البدء السريع

```bash
# استنساخ المستودع
git clone https://github.com/abdelfattahhussam/carelink.git
cd carelink

# تثبيت الحزم
flutter pub get

# التشغيل باستخدام واجهة خلفية محاكاة (لا حاجة لواجهة برمجة تطبيقات حقيقية)
flutter run --dart-define=USE_MOCK=true

# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze
```

### هيكل المشروع

يرجى الرجوع إلى ملف [tree.txt](tree.txt) في جذر المستودع لمعرفة الهيكل الكامل للمشروع.

### حسابات تجريبية (في وضع المحاكاة فقط)

| الدور | البريد الإلكتروني | كلمة المرور |
|---|---|---|
| مستخدم | user@test.com | أي قيمة |
| صيدلي | pharmacist@test.com | أي قيمة |

### لقطات الشاشة

> سيتم إضافة لقطات الشاشة قريباً — التطبيق يعمل على نظامي Android و iOS.
> لالتقاط الصور: `flutter run --dart-define=USE_MOCK=true` على جهاز فعلي أو محاكي.

### خطة التطوير

#### التكامل مع الواجهة الخلفية (الخطوة القادمة)
- [ ] ربط REST API (استبدال MockInterceptor)
- [ ] مصادقة JWT مع رموز التحديث (refresh tokens)
- [ ] ترقيم الصفحات (Pagination) الحقيقي

#### ميزات مستقبلية
- [ ] إشعارات الدفع (FCM)
- [ ] رفع الصور إلى التخزين السحابي
- [ ] دعم فروع متعددة للصيدلي
- [ ] شاشة سجل التدقيق (Audit log)
