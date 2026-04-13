# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Blink is an AI link archiving iOS app (AI 링크 아카이빙 서비스). It summarizes and categorizes saved links using AI, with folder-based archiving. The app includes a Share Extension for saving links from other apps.

- **Minimum deployment**: iOS 16.2
- **Swift version**: 6.0
- **Bundle ID**: `com.kyuchul.blink`

## Build System

The project uses **Tuist 4.113.1** with SPM for dependency management.

```bash
# Generate Xcode project (required before building)
tuist install        # Fetch SPM dependencies
tuist generate       # Generate .xcworkspace and .xcodeproj files

# Build
tuist build

# Clean and regenerate
tuist clean
tuist install && tuist generate
```

The workspace is named **Blink** (`Workspace.swift`). After `tuist generate`, open `Blink.xcworkspace`.

## Module Architecture

All modules live under `Projects/` as static frameworks:

```
Projects/
├── App/              # Main app target + ShareExtension
├── Feature/          # UI/presentation layer (single module, scenes inside)
│   └── Scene/        # 17 feature screens (Home, Auth, SaveLink, StorageBox, etc.)
├── Domain/           # Business logic interfaces (e.g., Folder)
├── Core/             # Services and infrastructure
│   ├── BKNetwork/    # Moya-based networking, token interceptor
│   ├── Services/     # Social login, pasteboard, notifications, ads
│   ├── Analytics/    # Firebase Analytics event tracking
│   └── Models/       # Shared data models
└── Shared/           # Cross-cutting concerns
    ├── Common/       # Extensions, Keychain, UserDefaults, URL literals
    ├── CommonFeature/# Design system (BK-prefixed components: BKTextField, BKBottomSheet, etc.)
    ├── ThirdParty/   # Third-party library re-exports
    └── CommonFeatureThirdParty/
```

Module definitions: `Plugins/DependencyPlugin/` (module paths, dependency mappings).
Target templates: `Tuist/ProjectDescriptionHelpers/` (Target+Template, Project+Template, Settings).
Resource code generation: `Tuist/ResourceSynthesizers/` (stencil templates for Assets, Fonts, JSON, Lottie).

## Architecture Pattern: TCA (The Composable Architecture)

Every feature follows this structure:

- **`<Name>Feature.swift`** — `@Reducer` with `@ObservableState` State, Action (including `BindableAction`), and body
- **`<Name>View.swift`** — SwiftUI view using `@Perception.Bindable var store: StoreOf<Feature>`
- Views wrap content in `WithPerceptionTracking { }`
- Child features composed via `Scope` reducer and `store.scope(state:action:)`
- Navigation uses TCA's enum-based state (`@Presents`, `ifLet`, `ifCaseLet`)
- Side effects use `@Dependency` for injection (networking clients, services)
- Delegation between features via `Action.Delegate` cases

## Key Dependencies

- **ComposableArchitecture** 1.23.1+ — state management
- **Moya** 15.0.3+ — networking
- **Firebase** 12.7.0+ — Crashlytics, Analytics, Messaging
- **Kingfisher** 8.6.2+ — image loading
- **KakaoSDK** 2.22.0 (exact) — Kakao social login
- **GoogleSignIn** 9.0.0+ — Google social login
- **GoogleMobileAds** 12.14.0+
- **SwiftUI Introspect** 26.0.0+ — UIKit bridge

## Commit Convention

Commits use a Korean-language prefix tag format:

```
[ADD] 새 기능 추가
[FEAT] 기능 구현
[FIX] 버그 수정
[UPDATE] 기존 기능 개선
[REFACTOR] 리팩토링
```

Branch naming: `feature/#<issue-number>` from `develop`.

## Navigation Flow

`RootFeature` manages top-level app state transitions:
**Splash → Login → Onboarding → MainTab**

`TabBarFeature` manages the main tab navigation (Home, StorageBox, Setting, etc.).
