<div align="center">

# 🏥 CareLink | Smart Healthcare Mobile Platform

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-brightgreen?style=for-the-badge)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC-blueviolet?style=for-the-badge)](https://pub.dev/packages/flutter_bloc)
[![Routing](https://img.shields.io/badge/Routing-Go_Router-FF4500?style=for-the-badge)](https://pub.dev/packages/go_router)

> **Improving access to medicines through smart mobile technology.**

*CareLink connects Patients, Pharmacists, and Donors in one seamless ecosystem. Whether you are searching for rare medicines, managing a pharmacy's digital inventory, or donating unused medicines to your community, CareLink bridges the gap.*

[English](#-english) • [العربية](#-arabic)

</div>

---

## 🌟 Why CareLink?

Accessing critical medications can be frustrating due to localized stock shortages, poor visibility of available inventory, or communication gaps. CareLink solves this by digitizing the process:

- **For Patients:** Easily search for medicines across pharmacies, upload prescriptions, and request urgent medications.
- **For Donors:** Safely donate unused, unexpired medicines to verified pharmacies to help those in need.
- **For Pharmacists:** Manage incoming medicine requests, review donations, monitor inventory expiry, and oversee secure medicine handovers.

---

## 🚀 Core Features

### 👥 Comprehensive Multi-Role System
CareLink provides tailored experiences and dedicated dashboards based on the user's role:

| Feature | Patient 🤒 | Pharmacist 👨‍⚕️ | Donor 🤝 |
|---|:---:|:---:|:---:|
| **Search & Filter Medicines** | ✅ | ✅ | ✅ |
| **Request Medicines & Upload Prescriptions** | ✅ | — | — |
| **Track Request Status** | ✅ | — | — |
| **Donate Medicines** | — | — | ✅ |
| **Review & Manage Requests/Donations** | — | ✅ | — |
| **Mutual QR Code Secure Handover** | ✅ | ✅ | ✅ |
| **Expiry Warnings & Inventory Analytics** | — | ✅ | — |

### ✨ Highlighted Technical Features
- **🌍 Dynamic Pharmacy Location System:** Filter medicines and pharmacies by Governorate, City, and District.
- **🔐 Secure QR Handover:** A robust mutual QR confirmation workflow ensuring medicines are delivered to the right person securely.
- **🔔 Real-time Notifications:** In-app notification system covering donation approvals, new requests, expiry warnings, and status changes.
- **🌗 Theming & Localization:** Native Light/Dark modes seamlessly integrated with full English (en) and Arabic (ar) localization.
- **🧪 Advanced Mock API:** A custom-built Dio Interceptor that simulates a complete backend (authentication, CRUD operations, relationships) allowing for offline development and rapid prototyping.

---

## 🛠 Tech Stack & Architecture

CareLink is built with scalability, maintainability, and modern Flutter best practices in mind.

| Category | Technology |
|---|---|
| **Framework** | Flutter |
| **Language** | Dart |
| **Architecture** | Clean Architecture (Presentation, Domain, Data) |
| **State Management** | BLoC / Cubit |
| **Routing & Navigation** | GoRouter (with Role-Based Access Control) |
| **Networking** | Dio (with custom Mock Interceptors) |
| **Storage** | `flutter_secure_storage` (Auth) & `SharedPreferences` (Settings) |
| **Testing** | 78+ Passing Tests (BLoC, Models, Validators) |
| **CI/CD** | GitHub Actions Pipeline (Analyze, Test, Build) |

### 🧱 Clean Architecture Layers
1. **Presentation Layer:** Screens, Widgets, and BLoC state holders.
2. **Domain Layer:** Entities, Repository interfaces / abstractions, and pure Business Logic.
3. **Data Layer:** Models, API Services, Mock Interceptors, and Repository implementations.
4. **Storage Layer:** `flutter_secure_storage` for auth data + `SharedPreferences` for app settings.
5. **Testing Layer:** Comprehensive suite of 78 passing tests covering BLoC, Models, and Validators.
6. **CI/CD Layer:** Automated GitHub Actions pipeline for linting, testing, and building.

*Note: Dependency Injection (e.g., GetIt) is planned as a future enhancement.*

---

## 📸 Screenshots *(Placeholders)*

<div align="center">
  <img src="https://via.placeholder.com/200x400.png?text=Login" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Patient+Home" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Pharmacy+Dashboard" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=QR+Handover" width="200"/>
</div>

---

## ⚙️ Installation & Running

### Prerequisites
- Flutter SDK `^3.11.1`
- Dart `^3.11.1`

### Quick Start (Mock Mode)
CareLink ships with a built-in mock API for offline development. **Mock mode must be explicitly enabled:**

```bash
# 1. Clone the repository
git clone https://github.com/To7a-2003/carelink.git
cd carelink

# 2. Get dependencies
flutter pub get

# 3. Run with mock backend (required until real backend is connected)
flutter run --dart-define=USE_MOCK=true
```

### Production / Real Backend
When a real backend is available, run without the flag:
```bash
flutter run
```

> ⚠️ **Note:** Running without `--dart-define=USE_MOCK=true` will produce network errors until a real backend is configured at `ApiEndpoints.baseUrl`.

### 🔑 Test Accounts (Mock Mode Only)
You can log in using the following mock credentials (password can be anything):
- **Donor:** `donor@test.com`
- **Patient:** `patient@test.com`
- **Pharmacist:** `pharmacist@test.com`

---

## 🎯 Future Roadmap

- [ ] **Real Backend Integration:** Swap out the mock interceptor for a live Node.js/NestJS REST API.
- [ ] **Push Notifications:** Integrate Firebase Cloud Messaging (FCM) for background alerts.
- [ ] **Live Chat:** Real-time messaging between users and pharmacists.
- [ ] **Google Maps Integration:** Visual map view for nearby pharmacies.
- [ ] **AI Prescription Parsing:** OCR scanning for automated prescription reading.

---

## 📫 Contact & Author

**Abdelfattah Hussam** - *Frontend Lead / Mobile Engineer*

- 🌐 **Portfolio:** [abdelfattahhussam.github.io](https://abdelfattahhussam.github.io)
- 💼 **LinkedIn:** [in/abdelfattahhussam](https://linkedin.com/in/abdelfattahhussam)
- 💻 **GitHub:** [@abdelfattahhussam](https://github.com/abdelfattahhussam)
- 📧 **Email:** abdelfattahhussam9@gmail.com

---

<br>

<div align="center" id="-arabic" dir="rtl">

# 🏥 CareLink | منصة الرعاية الصحية الذكية

> **تحسين الوصول إلى الأدوية من خلال التكنولوجيا الذكية.**

*تربط CareLink بين المرضى والصيادلة والمتبرعين في بيئة واحدة متكاملة. سواء كنت تبحث عن أدوية نادرة، أو تدير مخزون صيدليتك رقمياً، أو ترغب في التبرع بالأدوية غير المستخدمة لمجتمعك، فإن CareLink هي الحلقة المفقودة.*

</div>

<div dir="rtl">

## 🌟 لماذا CareLink؟
يواجه الكثيرون صعوبة في الوصول إلى الأدوية الهامة بسبب نقص المخزون المحلي أو ضعف التواصل. تحل CareLink هذه المشكلة عن طريق رقمنة العملية:
- **للمرضى:** البحث بسهولة عن الأدوية في الصيدليات، ورفع الروشتات الطبية، وطلب الأدوية العاجلة.
- **للمتبرعين:** التبرع الآمن بالأدوية غير المستخدمة (وغير المنتهية الصلاحية) للصيدليات المعتمدة لمساعدة المحتاجين.
- **للصيادلة:** إدارة طلبات الأدوية، مراجعة التبرعات، مراقبة تواريخ الصلاحية، والإشراف على التسليم الآمن للأدوية.

## 🚀 أبرز المميزات
- **نظام أدوار متعدد (مرضى، صيادلة، متبرعين)**
- **نظام تحديد مواقع الصيدليات:** (محافظة، مدينة، حي)
- **تسليم آمن عبر رمز الاستجابة السريعة (QR Code):** لضمان وصول الدواء للشخص الصحيح.
- **إشعارات لحظية وتنبيهات بانتهاء الصلاحية.**
- **دعم كامل للغتين العربية والإنجليزية مع الوضع الليلي/النهاري.**
- **بيئة Mock متكاملة للتطوير بدون إنترنت.**

</div>

<div align="center">
  <b>Built with passion for healthcare innovation 💙</b><br>
  CareLink — Connecting People to Care.
</div>
