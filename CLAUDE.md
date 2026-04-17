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

All modules live under `Projects/` as static frameworks, grouped into five top-level projects:

```
Projects/
├── App/                        # Main app target + ShareExtension
│   ├── Sources/                # BlinkApp, AppDelegate(Feature), Extensions
│   └── ShareExtension/         # Share extension target
├── BKFeatures/                 # UI/presentation layer (TCA)
│   ├── Sources/                # Feature scenes: Auth, Home, SaveLink, StorageBox,
│   │                           #  StorageBoxFeedList, EditLink, Link, Search,
│   │                           #  CalendarSearch, SummaryStatus, Setting,
│   │                           #  Splash, Root, TabBar, Common
│   └── ShareFeature/           # ShareExtension feature module
├── BKDesignSystem/             # Design system (BK-prefixed components, resources)
│   ├── BKDesignSystem/         # DesignSystem, Enum, PreferenceKey, ViewModifiers
│   └── BKDesignSystemThirdParty/ # Third-party re-exports for design layer
├── BKCore/                     # Services and infrastructure (per-Client modules)
│   ├── Clients/                # Each Client is its own static framework target:
│   │                           #  BKNetworkClient, AuthClient, UserClient,
│   │                           #  FeedClient(+Interface), FolderClient, LinkClient,
│   │                           #  NoticeClient, SocialLoginClient, KakaoChannelClient,
│   │                           #  GoogleMobileAdsClient, AnalyticsClient, AlertClient,
│   │                           #  ATTrackingManagerClient, UserNotificationClient,
│   │                           #  PasteboardClient, URLOpenHandlerClient,
│   │                           #  KeychainClient, UserDefaultsClient
│   └── NetworkCore/            # Shared networking core (reserved)
└── BKShared/                   # Cross-cutting shared code
    ├── BKCommon/               # Extensions, Error, FeedbackGenerator, Literal
    └── BKModel/                # Shared data models (Auth, Feed, Folder, Home, Link,
                                #  LinkDetail, Notice, Setting, AppVersionAPI, etc.)
```

Module definitions: `Plugins/DependencyPlugin/ProjectDescriptionHelpers/Modules.swift` — declares each top-level group (`App`, `Feature`, `DesignSystem`, `Core`, `Shared`) and the per-Client list under `Core.Clients`.
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
