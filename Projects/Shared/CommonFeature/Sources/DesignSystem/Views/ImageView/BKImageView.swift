//
//  BKImageView.swift
//  CommonFeature
//
//  Created by kyuchul on 9/4/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Kingfisher

public struct BKImageView: View {
  private let imageURL: URL?
  private let downsamplingSize: CGSize
  private let placeholder: Image
  
  public init(
    imageURL: String,
    downsamplingSize: CGSize,
    placeholder: Image
  ) {
    self.imageURL = URL(string: imageURL)
    self.downsamplingSize = CGSize(width: downsamplingSize.width, height: downsamplingSize.height)
    self.placeholder = placeholder
  }
  
  
  public var body: some View {
    KFImage(imageURL)
      .fade(duration: 0.25)
      .placeholder {
        placeholder
          .resizable()
          .frame(width: downsamplingSize.width, height: downsamplingSize.height)
      }
      .downsampling(size: downsamplingSize)
      .scaleFactor(UIScreen.main.scale)
      .cacheOriginalImage()
      .resizable()
      .scaledToFill()
  }
}
