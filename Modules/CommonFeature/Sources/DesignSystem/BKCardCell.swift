//
//  BKCardCell.swift
//  Blink
//
//  Created by 김규철 on 5/1/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Util

/// BKCardCell를 사용하는 부모뷰에서 GeometryReader 사용 필수
///
///  GeometryReader { proxy in
///         ScrollView {
///             LazyVStack(content: {
///                 ForEach(1...10, id: \.self) { count in
///                     BKCardCell(width: proxy.size.width ...)
///                }
///            }
///        }
///    }

public struct BKCardCell: View {
    public var width: CGFloat
    public var sourceTitle: String
    public var sourceImage: Image
    public var saveAction: () -> Void
    public var menuAction: () -> Void
    public var title: String
    public var description: String
    public var keyword: [String]
    public var isUncategorized: Bool
    public var recommendedFolders: [String]?
    public var recommendedFolderAction: (() -> Void)?
    public var addFolderAction: (() -> Void)?
    
    public init(width: CGFloat, sourceTitle: String, sourceImage: Image, saveAction: @escaping () -> Void, menuAction: @escaping () -> Void, title: String, description: String, keyword: [String], isUncategorized: Bool = false, recommendedFolders: [String]? = nil, recommendedFolderAction: (() -> Void)? = nil, addFolderAction: (() -> Void)? = nil) {
        self.width = width
        self.sourceTitle = sourceTitle
        self.sourceImage = sourceImage
        self.saveAction = saveAction
        self.menuAction = menuAction
        self.title = title
        self.description = description
        self.keyword = keyword
        self.isUncategorized = isUncategorized
        self.recommendedFolders = recommendedFolders
        self.recommendedFolderAction = recommendedFolderAction
        self.addFolderAction = addFolderAction
    }
    
    public var body: some View {
        ZStack {
            Color.bkColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                makeHeaderSection()
                
                makeBodySection()
                    .fixedSize(horizontal: false, vertical: true)
                
                BKChipView(keyword: keyword, textColor: .bkColor(.gray700), strokeColor: .bkColor(.gray500), font: .semiBold(size: ._11))
                    .padding(.leading, -1)
                
                if isUncategorized {
                    makeUncategorizedSection()
                        .padding(.top, 8)
                }
            }
            .padding(EdgeInsets(top: 16, leading: 14, bottom: 20, trailing: 14))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    }
            
    @ViewBuilder
    private func makeHeaderSection() -> some View {
        HStack {
            HStack(spacing: 6) {
                sourceImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text(sourceTitle)
                    .font(.regular(size: ._12))
                    .foregroundColor(.bkColor(.gray700))
            }
            
            Spacer()
            
            makeHeaderIconsSection()
        }
    }
    
    @ViewBuilder
    private func makeHeaderIconsSection() -> some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                saveAction()
            } label: {
                BKIcon(image: CommonFeatureAsset.Images.icoSave.swiftUIImage, color: .bkColor(.gray900), size: CGSize(width: 20, height: 20))
            }
            
            Button {
                menuAction()
            } label: {
                BKIcon(image: CommonFeatureAsset.Images.icoMoreVertical.swiftUIImage, color: .bkColor(.gray600), size: CGSize(width: 20, height: 20))
            }
        }
    }
        
    @ViewBuilder
    private func makeBodySection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.semiBold(size: ._16))
                .foregroundStyle(Color.bkColor(.gray900))
                .lineLimit(1)
            
            Text(description)
                .font(.regular(size: ._14))
                .foregroundStyle(Color.bkColor(.gray700))
                .lineSpacing(2)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func makeUncategorizedSection() -> some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundStyle(Color.bkColor(.gray400))
                .padding(.bottom, 12)
            
            HStack(spacing: 2) {
                CommonFeatureAsset.Images.icoConceptStar.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("추천 폴더")
                    .font(.semiBold(size: ._14))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(recommendedFolders ?? [], id: \.self) { text in
                        makeRecommendedFolderText(text)
                            .onTapGesture {
                                recommendedFolderAction?()
                            }
                    }
                    
                    makeAddFolerButton()
                        .onTapGesture {
                            addFolderAction?()
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeRecommendedFolderText(_ text: String) -> some View {
        Text(text)
            .font(.semiBold(size: ._13))
            .foregroundColor(.bkColor(.main300))
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.bkColor(.main50))
            )
    }
    
    @ViewBuilder
    private func makeAddFolerButton() -> some View {
        BKIcon(image: CommonFeatureAsset.Images.icoPlus.swiftUIImage, color: .bkColor(.main300), size: CGSize(width: 14, height: 14))
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(
                Circle()
                    .fill(Color.bkColor(.main50))
            )
    }
}

// MARK: - BKCardCell Height

extension BKCardCell {
    private func calculateViewHeight(text: String, width: CGFloat) -> CGFloat {
        return text.calculateHeight(font: UIFont.regular(size: ._14), width: width) <= 20 ? 146 : 166
    }
}
