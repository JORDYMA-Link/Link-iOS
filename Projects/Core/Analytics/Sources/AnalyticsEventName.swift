//
//  AnalyticsEventName.swift
//  Analytics
//
//  Created by kyuchul on 11/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public enum AnalyticsEventName: String {
  // 로그인
  case kakaoLoginClicked = "kakao_login_clicked"
  case appleLoginClicked = "apple_login_clicked"
  
  // 온보딩
  case onboardingSkipClicked = "onboarding_skip_clicked"
  case onboardingNextClicked = "onboarding_next_clicked"
  case onboardingConfirmClicked = "onboarding_confirm_clicked"
  
  // 홈
  case homeSummaryClicked = "home_summary_clicked"
  case homeSummaringFeedClicked = "home_summaring_feed_clicked"
  case homeSearchFeedClicked = "home_search_feed_clicked"
  case homeCalenderClicked = "home_calender_clicked"
  case homeFeedClicked = "home_feed_clicked"
  case homeTabbarStorageboxClicked = "home_tabbar_storagebox_clicked"
  
  // 링크요약
  case feedSummaryClicked = "feed_summary_clicked"
  
  // 링크요약리스트
  case summarizedFeedClicked = "summarized_feed_clicked"
  
  // 요약 완료
  case feedSaveConfirmClicked = "feed_save_confirm_clicked"
  case feedSaveBookmarkedClicked = "feed_save_bookmarked_clicked"
  
  // 피드 디테일
  case feedDetailLinkButtonClicked = "feed_detail_link_button_clicked"
  
  // 링크 검색
  case searchFeedSearchbarClicked = "search_feed_searchbar_clicked"
  case searchFeedRecentKeywordClicked = "search_feed_recent_keyword_clicked"
  case searchFeedFeedClicked = "search_feed_feed_clicked"
  
  // 폴더함
  case storageboxFolderClicked = "storagebox_folder_clicked"
  case storageboxFeedListSearchFeedClicked = "storagebox_feed_list_search_feed_clicked"
  case storageboxFeedListCalenderClicked = "storagebox_feed_list_calender_clicked"
  case storageboxFeedListFeedClicked = "storagebox_feed_list_feed_clicked"
  
  // 캘린더
  case calenderFeedClicked = "calender_feed_clicked"
}
