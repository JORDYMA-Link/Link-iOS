//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import SwiftUIIntrospect

struct StorageBoxView: View {
    @StateObject var scrollViewDelegate = StorageBoxScrollViewDelegate()
    
    @State private var contentText: String = ""
    @State private var pushToContentList = false
    @State private var isPresented = false
    @State private var isHiddenDivider = false
    
    var body: some View {
        VStack(spacing: 0) {
            makeNavigationView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        Color.bkColor(.white)
                        
                        TextField("콘텐츠를 찾아드립니다.", text: $contentText)
                            .frame(height: 43)
                            .background(Color.bkColor(.gray300))
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
                    }
                    
                    Divider()
                        .foregroundStyle(Color.bkColor(.gray400))
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible())], spacing: 16) {
                        makeAddStorageBoxCell()
                            .onTapGesture {
                                print("폴더 추가하기")
                            }
                        
                        ForEach(1..<20) { index in
                            makeStorageBoxCell(
                                count: 90,
                                name: "할리스커피",
                                menuAction: {
                                    isPresented = true
                                }
                            )
                            .onTapGesture {
                                pushToContentList.toggle()
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                    .background(Color.bkColor(.gray300))
                }
            }
            .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
                scrollView.delegate = scrollViewDelegate
            }
        }
        .background(Color.bkColor(.white))
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(scrollViewDelegate.$contentOffset.receive(on: DispatchQueue.main)) { isHidden in
            isHiddenDivider = isHidden
            
        }
        .navigationDestination(isPresented: $pushToContentList) {
            StorageBoxContentListView()
        }
        .bottomSheet(isPresented: $isPresented, detents: [.height(154)], leadingTitle: "폴더 설정") {
            makeMenuBottomSheetContent()
                .padding(.horizontal, 16)
        }
    }
}

extension StorageBoxView {
    @ViewBuilder
    private func makeNavigationView() -> some View {
        VStack(spacing: 0) {
            makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
                .padding(.horizontal, 16)
            
            Divider()
                .foregroundStyle(Color.bkColor(.gray400))
                .opacity(isHiddenDivider ? 1 : 0)
        }
    }
    
    @ViewBuilder
    private func makeAddStorageBoxCell() -> some View {
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
    
    @ViewBuilder
    private func makeStorageBoxCell(count: Int, name: String, menuAction: @escaping () -> Void) -> some View {
        ZStack {
            Color(.bkColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(count)개")
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
                
                Text(name)
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
    
    @ViewBuilder
    private func makeMenuBottomSheetContent() -> some View {
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
}

@MainActor
final class StorageBoxScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
    @Published var contentOffset = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.contentOffset = scrollView.contentOffset.y > 80
        }
    }
}

#Preview {
    NavigationStack {
        StorageBoxView()
    }
}
