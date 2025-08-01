//
//  ShareRootView.swift
//  ShareExtension
//
//  Created by Claude on 8/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

// MARK: - ShareRootView

struct ShareRootView: View {
  @Perception.Bindable var store: StoreOf<ShareRootFeature>
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 20) {
        // 헤더
        HStack {
          Text("Blink 공유")
            .font(.title2)
            .fontWeight(.semibold)
          
          Spacer()
          
          Button(action: {
            store.send(.closeButtonTapped)
          }) {
            Image(systemName: "xmark")
              .font(.system(size: 18, weight: .medium))
              .foregroundColor(.secondary)
          }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        
        // 로고
        VStack(spacing: 12) {
          Image(systemName: "link.circle.fill")
            .font(.system(size: 60))
            .foregroundColor(.blue)
          
          Text("링크를 저장하고 요약해보세요")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        // 키체인 정보 카드
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Image(systemName: "key.fill")
              .font(.system(size: 16))
              .foregroundColor(.blue)
            
            Text("인증 정보")
              .font(.headline)
              .fontWeight(.medium)
          }
          
          if store.isLoading {
            HStack {
              ProgressView()
                .scaleEffect(0.8)
              Text("토큰 정보 로딩 중...")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          } else {
            VStack(alignment: .leading, spacing: 12) {
              InfoRow(title: "Access Token", value: store.accessToken)
              InfoRow(title: "Refresh Token", value: store.refreshToken)
            }
          }
        }
        .padding(20)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal, 20)
        
        Spacer()
        
        // 액션 버튼들
        VStack(spacing: 12) {
          Button(action: {
            // 링크 저장 액션
          }) {
            HStack {
              Image(systemName: "plus.circle.fill")
              Text("링크 저장하기")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .cornerRadius(12)
          }
          
          Button(action: {
            store.send(.closeButtonTapped)
          }) {
            Text("취소")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color(UIColor.systemGray6))
              .cornerRadius(12)
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
      .background(Color(UIColor.systemBackground))
      .onAppear {
        store.send(.onAppear)
      }
    }
  }
}

// MARK: - Helper Views

private struct InfoRow: View {
  let title: String
  let value: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title)
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(.secondary)
      
      Text(value)
        .font(.system(.body, design: .monospaced))
        .foregroundColor(.primary)
        .lineLimit(2)
        .truncationMode(.middle)
    }
  }
}
