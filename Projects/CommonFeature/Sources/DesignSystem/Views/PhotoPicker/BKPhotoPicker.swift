//
//  BKPhotoPicker.swift
//  CommonFeature
//
//  Created by kyuchul on 7/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import PhotosUI

public enum PhotoPickerError {
  case type
  case size
  
  public var title: String {
    switch self {
    case .type:
      return "지원 불가"
    case .size:
      return "용량 초과"
    }
  }
  
  public var message: String {
    switch self {
    case .type:
      return "JPG, PNG 형식을 제외한 파일 형식은 업로드할 수 없습니다"
    case .size:
      return "선택한 이미지 크기가 5MB를 초과합니다 다시 선택해주세요"
    }
  }
}

public struct BKPhotoPicker<Content: View>: View {
  @State private var selectedPhotos: [PhotosPickerItem] = []
  @Binding private var selectedImages: [UIImage]
  @Binding private var isPresentedError: Bool
  @Binding private var isPhotoError: PhotoPickerError?
  private let photoLibrary: PHPhotoLibrary
  private let content: () -> Content
  private let maximumByteSize: Int = 5000000
  private enum imageType: String {
    case jpeg = "jpeg"
    case png = "png"
  }
  
  public init(
    selectedImages: Binding<[UIImage]>,
    isPresentedError: Binding<Bool> = .constant(false),
    isPhotoError: Binding<PhotoPickerError?> = .constant(nil),
    photoLibrary: PHPhotoLibrary = .shared(),
    content: @escaping () -> Content) {
      self._selectedImages = selectedImages
      self._isPresentedError = isPresentedError
      self._isPhotoError = isPhotoError
      self.content = content
      self.photoLibrary = photoLibrary
    }
  
  public var body: some View {
    let photoPicker = PhotosPicker(
      selection: $selectedPhotos,
      maxSelectionCount: 1,
      matching: .images,
      photoLibrary: photoLibrary
    ) {
      content()
    }
    
    if #available(iOS 17.0, *) {
      photoPicker
        .onChange(of: selectedPhotos) { _, newValue in
          loadTransferable(from: newValue)
        }
    } else {
      photoPicker
        .onChange(of: selectedPhotos, perform: { newValue in
          loadTransferable(from: newValue)
        })
    }
  }
}

extension BKPhotoPicker {
  @MainActor
  private func loadTransferable(from photoSelection: [PhotosPickerItem]) {
    for photo in photoSelection {
      guard let fileExtension = photo.supportedContentTypes.first?.preferredFilenameExtension else {
        isPresentedError = true
        return
      }
      
      guard fileExtension.contains(imageType.jpeg.rawValue) || fileExtension.contains(imageType.png.rawValue) else {
        DispatchQueue.main.async {
          isPhotoError = .type
        }
        return
      }
      
      photo.loadTransferable(type: Data.self) { result in
        switch result {
        case .success(let data):
          if let data = data {
            guard data.count <= maximumByteSize else {
              DispatchQueue.main.async {
                isPhotoError = .size
              }
              return
            }
            
            if let image = UIImage(data: data) {
              DispatchQueue.main.async {
                selectedImages.removeAll()
                selectedImages.append(image)
              }
            }
          }
        case .failure:
          isPresentedError = true
        }
      }
    }
    
    selectedPhotos.removeAll()
  }
}
