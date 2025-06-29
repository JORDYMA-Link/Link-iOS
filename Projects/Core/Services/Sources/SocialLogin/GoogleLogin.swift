//
//  GoogleLogin.swift
//  Services
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

import Models

import GoogleSignIn

public enum GoogleErrorType: Error {
  case rootview
  case dismissSignIn
  case invalidSignInResult
  case invalidToken
}

final class GoogleLogin: NSObject {
  private var continuation: CheckedContinuation<SocialLoginInfo, Error>? = nil
  
  /// Handle GoogleLoginUrl
  func handleGoogleLoginUrl(url: URL) {
    GIDSignIn.sharedInstance.handle(url)
  }
  
  /// 구글 로그인
  @MainActor
  func googleLogin() async throws -> SocialLoginInfo {
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
      
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first,
            let rootViewController = window.rootViewController else {
        self.continuation?.resume(throwing: GoogleErrorType.rootview)
        self.continuation = nil
        return
      }
      
      GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
        if let _ = error {
          self.continuation?.resume(throwing: GoogleErrorType.dismissSignIn)
          self.continuation = nil
          return
        }
        
        guard let signInResult = signInResult else {
          self.continuation?.resume(throwing: GoogleErrorType.invalidSignInResult)
          self.continuation = nil
          return
        }
        
        signInResult.user.refreshTokensIfNeeded { user, error in
          if let error = error {
            self.continuation?.resume(throwing: error)
            self.continuation = nil
            return
          }
          
          guard let user = user,
                let idToken = user.idToken?.tokenString else {
            self.continuation?.resume(throwing: GoogleErrorType.invalidToken)
            self.continuation = nil
            return
          }
          
          let info = SocialLoginInfo(idToken: idToken, provider: .google)
          self.continuation?.resume(returning: info)
          self.continuation = nil
        }
      }
    }
  }
}
