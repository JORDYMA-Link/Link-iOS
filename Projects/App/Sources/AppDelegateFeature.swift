//
//  AppDelegateFeature.swift
//  Blink
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services

import ComposableArchitecture
import FirebaseCore
import FirebaseMessaging

@Reducer
struct AppDelegateFeature {
  @ObservableState
  struct State: Equatable {
  }
  
  enum Action {
    case didFinishLaunching
    case didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data)
    
    case initKakaoSDK
    case setUpNotificationCenter
    case setUpFirebase
    
    case setUserNotificationCenterDelegate
    case setUserNotificationCenterAuthorization
    case setUserNotifications(UserNotificationClient.DelegateEvent)
    
    case setFirebaseConfigure
    case setFirebaseIsAutoInitEnabled
    case setFirebaseApnsToken(Data)
    case setFirebaseToken
  }
  
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.userNotificationClient) private var userNotificationClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        return .run { send in
          /// KakaoSDK init
          await send(.initKakaoSDK)
          /// UserNotification 설정
          await send(.setUpNotificationCenter)
          /// Firebase 설정
          await send(.setUpFirebase)
        }
        
      case let .didRegisterForRemoteNotificationsWithDeviceToken(deviceToken):
        return .run { send in
          await send(.setFirebaseApnsToken(deviceToken))
          await send(.setFirebaseToken)
        }
        
      case .initKakaoSDK:
        socialLogin.initKakaoSDK()
        return .none
        
      case .setUpNotificationCenter:
        return .run { send in
          // 메시지 수신
          await send(.setUserNotificationCenterDelegate)
          // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
          await send(.setUserNotificationCenterAuthorization)
        }
        
      case .setUpFirebase:
        return .run { send in
          await send(.setFirebaseConfigure)
          await send(.setFirebaseIsAutoInitEnabled)
        }
        
      case .setUserNotificationCenterDelegate:
        return .run { send in
          for await event in self.userNotificationClient.delegate() {
            await send(.setUserNotifications(event))
          }
        }
        
      case .setUserNotificationCenterAuthorization:
        return .run { send in
          let authorizationStatus = await self.userNotificationClient.getAuthorizationStatus()
          
          if authorizationStatus == .notDetermined {
            // 알림 권한 설정 팝업 노출
            try await self.userNotificationClient.requestAuthorization()
          }
          
          // device token 요청
          await self.userNotificationClient.registerForRemoteNotifications()
        }
        
      case let .setUserNotifications(.willPresentNotification(_, completionHandler)):
        // foreground에서 노티 수신 방법 설정
        return .run { send in completionHandler([.banner, .badge, .sound]) }
        
      case let .setUserNotifications(.didReceiveResponse(_, completionHandler)):
        //  백그라운드에서 푸시 알림을 탭했을 때 실행
        return .run { @MainActor _ in completionHandler() }
        
      case .setFirebaseConfigure:
        FirebaseApp.configure()
        return .none
        
      case .setFirebaseIsAutoInitEnabled:
        Messaging.messaging().isAutoInitEnabled = true
        return .none
        
      case let .setFirebaseApnsToken(deviceToken):
        Messaging.messaging().apnsToken = deviceToken
        return .none
        
      case .setFirebaseToken:
        Messaging.messaging().token { token, error in
          if let error = error {
            debugPrint(error)
          } else if let token {
            userDefault.set(token, .fcmToken)
          }
        }
        return .none
      }
    }
  }
}

