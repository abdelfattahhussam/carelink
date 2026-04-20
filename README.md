# 🏥 CareLink | Smart Healthcare Mobile Platform

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-brightgreen?style=for-the-badge)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blueviolet?style=for-the-badge)](https://pub.dev/packages/flutter_bloc)

> **Improving access to medicines through smart mobile technology.**

CareLink is a Flutter-based healthcare application designed to connect **Patients, Pharmacists, and Donors** in one ecosystem. The platform helps users search for medicines, request unavailable items, upload prescriptions, track requests, and complete secure medicine pickup workflows.

---

## 🌟 Why This Project Matters

Access to important medicines can be difficult due to stock shortages, lack of visibility, or communication gaps.

CareLink aims to simplify this process by offering:

- Faster medicine request workflows  
- Better coordination between users and pharmacies  
- Secure handover using QR confirmation  
- Community support through medicine donation flows

---

## 🚀 Key Features

### 👥 Multi-Role System

The app supports three user roles with dedicated experiences:

| Feature | Patient | Pharmacist | Donor |
|---|---|---|---|
| Search Medicines | ✅ | ✅ | ✅ |
| Prescription Upload | ✅ | — | — |
| Request Tracking | ✅ | — | — |
| Review Requests | — | ✅ | — |
| Approve / Reject Flow | — | ✅ | — |
| Secure QR Pickup | ✅ | ✅ | — |
| Donation Flow | — | — | ✅ |

---

### 📱 Core Features

- Medicine search
- Request medicine with prescription upload
- Request status tracking
- Pharmacist request review system
- Dynamic quantity handling (boxes / strips)
- QR-based secure pickup
- Arabic / English localization
- Dark / Light mode
- Responsive UI
- Mock API layer ready for backend integration

---

## 🛠 Tech Stack

| Category | Tools |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State Management | BLoC / Cubit |
| Architecture | Clean Architecture |
| Version Control | Git / GitHub |
| Backend Status | Mock APIs / Ready for integration |

---

## 🧱 Architecture

The project follows **Clean Architecture** principles for better maintainability and scalability.

### Layers:

1. **Presentation Layer**  
   UI screens, Widgets, BLoC/Cubit

2. **Domain Layer**  
   Business rules, Use Cases

3. **Data Layer**  
   Models, Repositories, Data Sources

---

## 👤 My Role

**Frontend Lead / Main Flutter Developer**

Main responsibilities:

- Built core UI screens and flows
- Improved app UI/UX quality
- Organized project structure
- Implemented BLoC state management
- Developed role-based user workflows
- Prepared frontend for backend APIs
- Solved Android build issues
- Solved iOS signing / deployment issues
- Managed GitHub collaboration workflow

---

## 🧩 Technical Challenges Solved

### Multi-Role Logic
Designed one application serving multiple user types with separate dashboards and workflows.

### QR Pickup Flow
Implemented a secure medicine handover confirmation process.

### Project Refactoring
Improved code structure using Clean Architecture principles.

### Cross-Platform Deployment
Resolved Android build and iOS signing issues during testing.

### Localization
Implemented Arabic / English support with RTL readiness.

---

## ⚙️ Installation

```bash
git clone https://github.com/To7a-2003/carelink.git
cd carelink
flutter pub get
flutter run
🚀 Future Improvements
Real backend API integration
Push notifications
Live chat between users and pharmacies
Maps for nearby pharmacies
OCR prescription scanning
Analytics dashboard
📫 Contact

Abdelfattah Hussam

🌐 Portfolio: https://abdelfattahhussam.github.io
💼 LinkedIn: https://linkedin.com/in/abdelfattahhussam
💻 GitHub: https://github.com/abdelfattahhussam
📧 Email: abdelfattahhussam9@gmail.com
<div align="center">

Built with passion for healthcare innovation.

CareLink — Connecting People to Care.

</div> ```
