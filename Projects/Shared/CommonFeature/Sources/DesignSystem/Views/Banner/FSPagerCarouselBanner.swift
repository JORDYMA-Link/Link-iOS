//
//  FSPagerCarouselBanner.swift
//  CommonFeature
//
//  Created by kyuchul on 12/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import FSPagerViewSwift

/// iOS 18.0 미만 Carousel 사용 시
public struct FSPagerCarouselBanner: UIViewRepresentable {
  private let bannerView = BannerView()
  
  @Binding private var bannerItems: [BannerItem]
  private let action: (BKBannerType) -> Void
  
  public init(
    bannerItems: Binding<[BannerItem]>,
    action: @escaping (BKBannerType) -> Void
  ) {
    self._bannerItems = bannerItems
    self.action = action
  }
  
  public func makeUIView(context: Context) -> BannerView {
    bannerView.pagerView.dataSource = context.coordinator
    bannerView.pagerView.delegate = context.coordinator
    return bannerView
  }
  
  public func updateUIView(_ uiView: BannerView, context: Context) {}
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
}

extension FSPagerCarouselBanner {
  final public class Coordinator: NSObject, FSPagerViewDataSource, FSPagerViewDelegate {
    private let parent: FSPagerCarouselBanner
    
    init(parent: FSPagerCarouselBanner) {
      self.parent = parent
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
      guard !parent.bannerItems.isEmpty else {
        parent.bannerView.pageControl.numberOfPages = 1
        return 1
      }
      
      parent.bannerView.pageControl.numberOfPages = parent.bannerItems.count
      return parent.bannerItems.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
      let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
      
      guard let item = parent.bannerItems[safe: index] else { return cell }
      
      cell.contentConfiguration = UIHostingConfiguration {
        BKBannerItem(type: item.type)
      }
      .margins(.all, 0)
      
      return cell
    }
    
    public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
      guard let item = parent.bannerItems[safe: index] else { return }
        
      parent.action(item.type)
    }
    
    public func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        parent.bannerView.pageControl.currentPage = targetIndex
    }
    
    public func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        parent.bannerView.pageControl.currentPage = pagerView.currentIndex
    }
  }
}

public final class BannerView: UIView {
  private let uiVIew: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    return view
  }()
  fileprivate lazy var pagerView: FSPagerView = {
    let pagerView = FSPagerView()
    pagerView.translatesAutoresizingMaskIntoConstraints = false
    pagerView.interitemSpacing = 1
    pagerView.itemSize = FSPagerView.automaticSize
    pagerView.decelerationDistance = 1
    pagerView.isInfinite = true
    pagerView.automaticSlidingInterval = 3.0
    pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    return pagerView
  }()
  fileprivate let pageControl: FSPageControl = {
    let pageControl = FSPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.itemSpacing = 5
    pageControl.interitemSpacing = 5
    pageControl.setFillColor(.black, for: .selected)
    pageControl.setFillColor(.lightGray, for: .normal)
    pageControl.numberOfPages = 1
    return pageControl
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BannerView {
  private func setUp() {
    addSubview(uiVIew)
    
    [pagerView, pageControl]
      .forEach { uiVIew.addSubview($0) }
    
    [pageControl]
      .forEach { uiVIew.bringSubviewToFront($0) }
    
    NSLayoutConstraint.activate([
      uiVIew.topAnchor.constraint(equalTo: topAnchor),
      uiVIew.leadingAnchor.constraint(equalTo: leadingAnchor),
      uiVIew.trailingAnchor.constraint(equalTo: trailingAnchor),
      uiVIew.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    
    NSLayoutConstraint.activate([
      pagerView.topAnchor.constraint(equalTo: uiVIew.topAnchor),
      pagerView.leadingAnchor.constraint(equalTo: uiVIew.leadingAnchor),
      pagerView.trailingAnchor.constraint(equalTo: uiVIew.trailingAnchor),
      pagerView.bottomAnchor.constraint(equalTo: uiVIew.bottomAnchor)
    ])
    
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
}
