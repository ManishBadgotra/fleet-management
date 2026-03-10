<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.41.4-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android" />
<img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
<img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" />

# 🚛 Fleet Management

**The all-in-one compliance companion for Indian Fleet Owners — built with Flutter.**

*Stop chasing paperwork. Start managing smarter.*

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [Features](#-features)
- [Pricing Tiers](#-pricing-tiers)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Build From Source](#-build-from-source)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🔍 Overview

**Fleet Management** is a cross-platform Flutter application designed specifically for Indian fleet operators to track, manage, and stay ahead of all vehicle documentation and RTO compliance requirements — all from a single, intuitive interface.

Whether you manage 2 vehicles or 200, Fleet Management centralises every permit, certificate, and renewal deadline into one clean dashboard. No spreadsheets, no sticky notes, no missed deadlines.

> Built for the road. Designed for the office.

---

## 🚧 Problem Statement

Fleet owners across India face a common, recurring operational nightmare:

- Juggling **multiple RTO documents** across vehicles with no unified tracking system
- **Missing renewal deadlines** for permits, fitness certificates, insurance, and PUC — leading to fines, off-road vehicles, and halted operations
- **No centralised tool** that understands Indian RTO compliance structures
- Costly **third-party compliance managers** that are inaccessible to small and mid-size operators

Fleet Management was built to eliminate this operational overhead — giving owners visibility, control, and timely alerts without any prior technical expertise.

---

## ✨ Features

### 📄 Document & Permit Management
- Track all Indian RTO-mandated vehicle documents — including Registration Certificate (RC), Fitness Certificate, Road Permits (State/National), PUC, Insurance, and more
- Visual **valid / invalid / expiring-soon** status indicators for every document across your entire fleet
- Supports all major vehicle categories recognised under the Motor Vehicles Act

### 🔔 Smart In-App Alerts
- Receive **in-app notifications** when any document is approaching its due date or has already expired
- Alerts are surfaced on your dashboard the moment you open the app — no configuration needed

### 👤 Single Profile, Multiple Devices
- One account. Log in seamlessly across multiple devices — mobile, tablet, or both
- Your fleet data stays in sync, always up to date regardless of which device you're on

### 🎨 Clean, Intuitive Interface
- Designed with clarity-first principles — minimal learning curve for operators of all technical backgrounds
- High-readability layouts, clear typography, and logical navigation built for daily use in fast-paced environments

---

## 💎 Pricing Tiers

| Feature | Free (Open Source) | Paid |
|---|:---:|:---:|
| RTO Document Tracking | ✅ | ✅ |
| Valid / Invalid / Due-Soon Status | ✅ | ✅ |
| In-App Alerts | ✅ | ✅ |
| Multi-Device Login | ✅ | ✅ |
| **Indian RTO Data API** | 🔑 Optional (Bring Your Own Key) | ✅ Pre-configured |
| **Auto-fetch Updated RTO Details** | ❌ Manual Entry / Update | ✅ Periodic Background Sync |
| **Fleet Data Sync (Cloud Database)** | 🔧 Self-hosted Required | ✅ Pre-configured |
| **Push Notifications** (without opening app) | ❌ | ✅ |
| **Custom Alert Timing** (set your own lead time) | ❌ | ✅ |

### 🆓 Free Tier
Full access to all core fleet tracking and in-app alert features. The free tier is fully functional for day-to-day fleet compliance management.

> ⚠️ **Free / Self-hosted Builds — What you need to know:**
>
> - **RTO Data API *(Optional)*:** Connecting a third-party RTO data API (such as from [Vahan](https://vahan.parivahan.gov.in/) or a licensed provider) enables automatic vehicle data lookup. This is entirely optional — if you prefer not to deal with API keys, you can manually enter your vehicle details and document dates directly in the app, no technical setup required.
> - **Manual Date Updates:** Vehicle document details and expiry dates do not update automatically in the free tier. Any changes to your fleet records — such as renewed permits or updated fitness certificates — need to be updated by you within the app.
> - **Cloud Database:** Multi-device fleet sync requires a backend database (e.g. Firebase Firestore, Supabase, or your own hosted solution). Without this, fleet data will remain local to the device it was entered on and will not carry over on new device logins. Refer to the [Build From Source](#-build-from-source) section for configuration steps.

### 🔑 Paid Tier
Paid subscribers get **fully pre-configured RTO data access, automatic background sync, and a managed cloud database** out of the box — no API key hunting, no database setup, no external signups. Vehicle document details are periodically fetched and refreshed in the background, so your fleet records stay accurate with what's currently registered online — without you having to lift a finger. Your entire fleet also syncs automatically the moment you log in on any new device, exactly as it was.

Additionally, unlock **proactive mobile push notifications** that alert you about expiring documents even when the app is closed, and set **custom reminder windows** (e.g., 30, 60, or 90 days before expiry) tailored to your operational workflow.

> 💡 **Self-hosted users:** The RTO data API, cloud database sync, and push notification infrastructure powering the Paid tier all rely on our managed backend. None of these will function in self-hosted builds unless you supply and configure your own equivalent services.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41.4 |
| Language | Dart |
| State Management | *(e.g., Riverpod / BLoC — update as applicable)* |
| Backend | *(e.g., Firebase / Supabase — update as applicable)* |
| Push Notifications | *(e.g., FCM — update as applicable)* |
| Authentication | *(e.g., Firebase Auth — update as applicable)* |

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed before proceeding:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — **v3.41.4**
- Dart SDK (bundled with Flutter)
- Android Studio or Xcode (for device emulation)
- A physical or virtual device running Android / iOS

Verify your Flutter installation:

```bash
flutter doctor
```

All checks should pass. Resolve any reported issues before continuing.

---

## 🔧 Build From Source

> Anyone is free to build and self-host this application. See the [Pricing Tiers](#-pricing-tiers) section for limitations that apply to self-hosted builds.

**1. Clone the repository**

```bash
git clone https://github.com/your-username/fleet-management.git
cd fleet-management
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Configure environment**

```bash
cp .env.example .env
```

Fill in the required environment variables in `.env` (API keys, backend URLs, etc.).

**4. Run the app**

```bash
# Debug mode
flutter run

# Release build — Android
flutter build apk --release

# Release build — iOS
flutter build ipa --release
```

---

## 🗂 Project Structure

```
fleet-management/
├── lib/
│   ├── core/               # App-wide constants, themes, utilities
│   ├── data/               # Repositories, data sources, models
│   ├── domain/             # Business logic, use cases, entities
│   ├── presentation/       # UI screens, widgets, state management
│   └── main.dart           # App entry point
├── assets/                 # Images, icons, fonts
├── test/                   # Unit and widget tests
├── android/                # Android-specific configuration
├── ios/                    # iOS-specific configuration
├── pubspec.yaml            # Dependencies & metadata
└── README.md
```

> Structure follows a clean architecture pattern. Adjust paths above if your project uses a different layout.

---

## 🤝 Contributing

This is a personal project and is **not actively seeking external contributions** — however, you are absolutely welcome to fork it and build your own version without any restrictions.

If you do wish to submit a Pull Request, you're welcome to do so, but please note:

> **⚠️ Merge is not guaranteed.** PRs are reviewed at the maintainer's discretion based on project direction, code quality, and scope fit. Submitting a PR does not imply it will be merged.

If you'd still like to contribute, here's how to go about it:

1. Fork the repository
2. Create a feature branch — `git checkout -b feature/your-feature-name`
3. Commit your changes — `git commit -m 'feat: describe your change'`
4. Push to the branch — `git push origin feature/your-feature-name`
5. Open a Pull Request with a clear description of what you've changed and why

Please follow existing code conventions and include relevant tests where applicable. Opening an issue to discuss your idea before writing code is strongly recommended — it avoids effort being spent on changes that may not align with the project's direction.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for full details.

The core application is open source. The managed push notification infrastructure powering the Paid tier is proprietary and not included in this repository.

---

<div align="center">

Made with ❤️ for Indian Fleet Operators &nbsp;|&nbsp; Built with Flutter 🐦

</div>
