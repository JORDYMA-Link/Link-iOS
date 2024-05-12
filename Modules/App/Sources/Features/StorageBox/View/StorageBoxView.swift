//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import UIKit

import CommonFeature

import Combine
import SwiftUIIntrospect

struct StorageBoxView: View {
    @StateObject var scrollViewDelegate = ScrollViewDelegate()
    
    @State private var contentText: String = ""
    @State private var pushToContentList = false
    @State private var isPresented = false
    @State private var isHiddenShadow = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                makeBKNavigationView(leadingType: .tab("폴더함"), trailingType: .none)
                if isHiddenShadow {
                    Color.gray
                        .frame(height: 6)
                        .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
                }
            }
            
            ScrollView(showsIndicators: false) {
                ZStack {
                    Color.white
                    
                    TextField("콘텐츠를 찾아드립니다.", text: $contentText)
                        .frame(height: 43)
                        .background(Color.bkColor(.gray300))
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
                }
                
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible())], spacing: 16) {
                    AddStorageBoxCell()
                        .onTapGesture {
                            print("폴더 추가하기")
                        }
                    
                    ForEach(1..<20) { index in
                        StorageBoxCell(
                            folderCount: 90,
                            folderName: "할리스커피",
                            menuAction: {
                                isPresented = true
                            }
                        )
                        .id(index)
                        .onTapGesture {
                            pushToContentList.toggle()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 32)
                .background(Color.bkColor(.gray300))
            }
            .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
                scrollView.delegate = scrollViewDelegate
            }
        }
        .onReceive(scrollViewDelegate.$contentOffset) { scroll in
                isHiddenShadow = scroll
        }
        .background(Color.bkColor(.white))
        .navigationDestination(isPresented: $pushToContentList) {
            StorageBoxContentListView()
        }
        .toolbar(.hidden, for: .navigationBar)
        //        .toolbar {
        //            ToolbarItem(placement: .topBarLeading) {
        //                LeadingItem(type: .tab("보관함"))
        //            }
        //        }
        .bottomSheet(isPresented: $isPresented, detents: [.height(154)], leadingTitle: "폴더 설정") {
            menuBottomSheetContent
                .padding(.horizontal, 16)
        }
    }
}

private struct AddStorageBoxCell: View {
    var body: some View {
        ZStack {
            Color(.bkColor(.white))
            
            VStack(alignment: .center, spacing: 4) {
                CommonFeatureAsset.Images.icoPlus.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.bkColor(.gray700))
                
                Text("추가하기")
                    .font(.regular(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray700))
            }
            .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: 80)
        .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    }
}

private struct StorageBoxCell: View {
    var folderCount: Int
    var folderName: String
    var menuAction: () -> Void
    
    var body: some View {
        ZStack {
            Color(.bkColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(folderCount)개")
                        .font(.regular(size: ._12))
                        .foregroundStyle(Color.bkColor(.gray800))
                        .lineLimit(1)
                    
                    Spacer(minLength: 4)
                    
                    Button(action: {
                        menuAction()
                    }, label: {
                        CommonFeatureAsset.Images.icoMoreVertical.swiftUIImage
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.bkColor(.gray600))
                    })
                }
                
                Text(folderName)
                    .font(.semiBold(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray900))
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: 80)
        .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    }
}

private var menuBottomSheetContent: some View {
    HStack(spacing:0) {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                print("폴더 이름 수정하기")
            }) {
                Text("폴더 이름 수정하기")
                    .font(.regular(size: ._16))
                    .foregroundStyle(Color.bkColor(.gray900))
                    .padding(.vertical, 8)
            }
            
            Button(action: {
                print("폴더 삭제하기")
            }) {
                Text("폴더 삭제하기")
                    .font(.regular(size: ._16))
                    .foregroundStyle(Color.bkColor(.red))
                    .padding(.vertical, 8)
            }
        }
        
        Spacer(minLength: 0)
    }
}

#Preview {
    NavigationStack {
        StorageBoxView()
    }
}

final class ScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
    @Published var contentOffset = false
    private var isScroll = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 50 && !isScroll {
            contentOffset = true
            isScroll = true
        } else if scrollView.contentOffset.y < 50 && isScroll {
            // 스크롤이 80 이하로 내려갔을 때만 isScroll을 false로 설정하여 다음 80 이상의 스크롤을 기다립니다.
            contentOffset = false
            isScroll = false
        }
    }
}
