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
    
    public init(width: CGFloat, sourceTitle: String, sourceImage: Image, saveAction: @escaping () -> Void, menuAction: @escaping () -> Void, title: String, description: String, keyword: [String]) {
        self.width = width
        self.sourceTitle = sourceTitle
        self.sourceImage = sourceImage
        self.saveAction = saveAction
        self.menuAction = menuAction
        self.title = title
        self.description = description
        self.keyword = keyword
        
    }
    
    public var body: some View {
        ZStack {
            Color.bkColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
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
                    
                    RightIconsSection(saveAction: { saveAction() }, menuAction: { menuAction() })
                }
                
                BodySection(title: title, description: description)
                    .fixedSize(horizontal: false, vertical: true)
                
                BKChipView(keyword: keyword, textColor: .bkColor(.gray700), strokeColor: .bkColor(.gray500), font: .semiBold(size: ._11))
            }
            .padding(EdgeInsets(top: 16, leading: 14, bottom: 20, trailing: 14))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: calculateViewHeight(text: description, width: width))
        .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    }
    
    private struct RightIconsSection: View {
        var saveAction: () -> Void
        var menuAction: () -> Void
        
        var body: some View {
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
    }
    
    private struct BodySection: View {
        var title: String
        var description: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.semiBold(size: ._16))
                    .foregroundStyle(Color.bkColor(.gray900))
                    .lineLimit(1)
                
                Text(description)
                    .font(.regular(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray700))
                    .lineLimit(2)
            }
        }
    }
}

// MARK: - BKCardCell Height

extension BKCardCell {
    private func calculateViewHeight(text: String, width: CGFloat) -> CGFloat {
        return text.calculateHeight(font: UIFont.regular(size: ._14), width: width) <= 20 ? 146 : 166
    }
}
