# 🎬 Mini Movie Explorer App

**Mini Movie Explorer** is a lightweight iOS application that lets users browse popular movies using The Movie Database (TMDB) API. The app presents movie posters in a grid and allows users to view detailed information about any selected movie — including genres, runtime, rating, production info, and more.


## 📱 Features

- Browse popular movies with pagination
- View movie details including genres, tagline, overview, release date, and more
- Favorite/unfavorite movies (locally persisted using UserDefaults)
- Smooth image loading with Kingfisher
- Modular architecture using MVVM + Clean Architecture



## 🧱 Architecture

This app is built using **Clean Architecture** combined with **MVVM** and **Dependency Injection**. The structure is modular and testable.



## 🔄 Layered Structure

```
├── Presentation/      // UI Layer (ViewControllers, ViewModels, Views)
├── Domain/            // Business Rules (Entities, UseCases, Interfaces)
├── Data/              // Data Sources (Repositories, DTOs, Network)
├── Utilities/         // Helpers (e.g. Persistence, UI Utilities)
├── Resources/         // Assets & Launch Screen
├── App/               // App entry points (AppDelegate, SceneDelegate)

```


## 🛠 Technologies

- Swift + UIKit
- MVVM + Clean Architecture
- Alamofire for HTTP networking
- Kingfisher for image downloading and caching
- UserDefaults for local persistence



## 🔄 Trade-offs & Decisions

- UserDefaults was used for simplicity in favoriting; for larger-scale persistence, CoreData or Realm would be more scalable.
- XIB files were chosen over storyboards for better modularity and reuse.
- A minimal dependency injection approach was implemented manually for simplicity, without external DI frameworks.
- Error handling is handled gracefully with basic UI fallback — however, a dedicated ErrorView or retry mechanism could enhance UX.
- Alamofire is used for network calls; Kingfisher is used for image loading and caching.

## Screenshots
<img src="https://github.com/user-attachments/assets/54bc5c65-864e-4c33-a8a8-09f6ece815e6" width="300" /> <img src="https://github.com/user-attachments/assets/46b05a14-75d2-44e7-824b-6f2cd633a7b1" width="300" /> <img src="https://github.com/user-attachments/assets/be21223e-1c62-4db7-93a7-1642c201c87d" width="300" />
