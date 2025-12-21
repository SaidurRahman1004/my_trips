# 📱 TravelSnap - Your Digital Travel Companion

<div align="center">

![TravelSnap Banner](https://i.ibb.co.com/Dg6YQxvL/travelsnap-logo.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**[📥 Download APK](https://github.com/SaidurRahman1004/my_trips/releases)** • **[🐛 Report Bug](https://github.com/SaidurRahman1004/my_trips/issues)** • **[💡 Request Feature](saidurrahman1004@gmail.com)**

  <p align="center">
    <strong>v1.0.0 Beta - Testing Release</strong>
  </p>
</div>

---

## 🌟 What is TravelSnap?

TravelSnap is a mobile app that helps travelers organize and preserve their memories.  Instead of having hundreds of random photos scattered in your gallery, TravelSnap creates a structured digital diary where each trip has its own space—with photos, locations, dates, and personal notes.

Think of it as your personal travel journal that never gets lost.

### The Problem It Solves:

- 📸 **Lost memories**: Photos buried in camera rolls, never to be seen again
- 🗺️ **No context**: Forgot where that amazing beach photo was taken
- 📱 **Data loss**: Phone lost or broken = memories gone forever
- 🔍 **Hard to find**: Scrolling through thousands of photos to find one trip

### The Solution:

- ✅ **Organized timeline**: All trips in one place, sorted by date
- ✅ **Automatic location tagging**: GPS captures where each memory was made
- ✅ **Cloud backup**: Safe in the cloud, accessible from any device
- ✅ **Quick search**: Find any trip by name, location, or description
- ✅ **Rich context**: Photos + location + story = complete memory

---

## ✨ Features (v1.0 Beta Temporary v1 For Testing)

This is the first public release.  Here's what works right now:

| Feature | Description | Status |
|---------|-------------|: ------:|
| **🔐 User Authentication** | Secure sign-up and login with email/password | ✅ |
| **📝 Create Trips** | Add new travel memories with title, description, and photo | ✅ |
| **📍 GPS Location Tagging** | Automatic location capture using device GPS | ✅ |
| **📸 Photo Integration** | Take photos or pick from gallery | ✅ |
| **☁️ Cloud Sync** | Real-time data synchronization with Firebase | ✅ |
| **🔍 Search Functionality** | Find trips by title, location, or keywords | ✅ |
| **🗑️ Delete Trips** | Remove unwanted memories (with confirmation) | ✅ |
| **🗺️ Google Maps Link** | View trip location on Google Maps | ✅ |
| **⚡ Real-time Updates** | Changes appear instantly (StreamBuilder) | ✅ |
| **💾 Cloud Backup** | All data stored securely on Firebase | ✅ |

### 🚧 What's NOT Included Yet:

- ❌ Offline mode (requires internet)
- ❌ Image caching (photos reload every time)
- ❌ Dark theme
- ❌ Social features (sharing, following, likes)
- ❌ Edit trip functionality
- ❌ Multi-photo support (one photo per trip currently)
- ❌ Advanced filters

These are planned for future releases based on user feedback.

---

## 📸 Screenshots(Temporary v1 For Testing)

<div align="center">
  <img src="https://i.ibb.co.com/DDssdKyp/login.jpg" alt="Login" width="200"/>
  <img src="https://i.ibb.co.com/rKN15MkD/home.jpg" alt="Home" width="200"/>
  <img src="https://i.ibb.co.com/B27p0PFm/add.jpg" alt="Add Trip" width="200"/>
  <img src="https://i.ibb.co.com/qYhT26Y8/detail.jpg" alt="Details" width="200"/>
</div>

> **Note:** Replace these placeholder images with actual app screenshots

---

## 🛠️ Tech Stack

**Frontend:**
- Flutter 3.10+
- Dart 3.0+
- Material Design 3

**Backend & Services:**
- Firebase Authentication (user management)
- Cloud Firestore (NoSQL database)
- Firebase Storage (image hosting)
- ImgBB API (temporary image hosting)

**Architecture:**
- Service-based architecture
- MVC pattern
- StreamBuilder for reactive UI

**Key Packages:**
```yaml
dependencies:
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.2
  cloud_firestore: ^6.1.0
  image_picker: ^1.2.1
  geolocator: ^14.0.2
  geocoding: ^4.0.0
  go_router: ^17.0.0
  google_fonts: ^6.3.3
  intl: ^0.20.2
  uuid: ^4.5.2
  http: ^1.6.0