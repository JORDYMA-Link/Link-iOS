//
//  AppleLogin.swift
//  Services
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation
import AuthenticationServices

import Models

enum AppleErrorType: Error {
  case invalidToken
  case invalidAuthorizationCode
}

final class AppleLogin: NSObject, ASAuthorizationControllerDelegate {
  private var continuation: CheckedContinuation<SocialLogin, Error>? = nil
  
  /// 애플 로그인
  @MainActor
  func appleLogin() async throws -> SocialLogin {
    return try await withCheckedThrowingContinuation { continuation in
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
      
      if self.continuation == nil {
        self.continuation = continuation
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let email = appleIDCredential.email
      print("appleLogin email \(email ?? "")")
      let fullName = appleIDCredential.fullName
      print("appleLogin fullName \(fullName?.description ?? "")")
      
      guard let tokenData = appleIDCredential.identityToken,
            let token = String(data: tokenData, encoding: .utf8) else {
        continuation?.resume(throwing: AppleErrorType.invalidToken)
        continuation = nil
        return
      }
      
      print("appleLogin token \(token)")
      
      guard let authorizationCode = appleIDCredential.authorizationCode,
            let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else {
          continuation?.resume(throwing: AppleErrorType.invalidAuthorizationCode)
          continuation = nil
          return
      }
      
      print("appleLogin authorizationCode \(authorizationCodeString)")
      
      let userIdentifier = appleIDCredential.user
      print("appleLogin authenticated user: \(userIdentifier)")
      
      let info = SocialLogin(id: userIdentifier, authorization: authorizationCodeString, identityToken: token, provider: .apple)
        
      continuation?.resume(returning: info)
      continuation = nil
      
    default:
      break
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      continuation?.resume(throwing: error)
      continuation = nil
  }
}
