//
//  BKModalCase.swift
//  CommonFeature
//
//  Created by 문정호 on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

public enum BKModalType {
    case linkLoading(checkAction: (()->Void), cancelAction: (()->Void))
    case cancelConfirm(checkAction: (()->Void), cancelAction: (()->Void))
    case custom(titleText:String, description: String, checkAction: (()->Void), cancelAction: (()->Void)?)
    case deleteFolder(checkAction: (()->Void), cancelAction: (()->Void))
    case deleteContent(checkAction: (()->Void), cancelAction: (()->Void))
    case withdrawNotice
    case logout(checkAction: (()->Void), cancelAction: (()->Void))
}

extension BKModalType {
    public var isLottieNeeded: Bool {
        switch self {
        case .linkLoading:
            return true
        default:
            return false
        }
    }
    
    public var modalTitle: String {
        switch self {
        case .linkLoading:
            return "잠시만 기다려주세요"
        case .cancelConfirm:
            return "정말 그만두시겠어요?"
        case .deleteFolder:
            return "폴더 삭제하기"
        case .deleteContent:
            return "삭제하기"
        case .withdrawNotice:
            return "유의사항"
        case .logout:
            return "로그아웃"
        case .custom(let titleText, _, _, _):
            return titleText
        }
    }
    
    public var modalDescription: String {
        switch self {
        case .linkLoading:
            return "블링크가 눈 깜짝할 새에 요약할게요"
        case .cancelConfirm:
            return "아직 링크가 저장되지 않았어요"
        case .deleteFolder:
            return "폴더를 삭제하시면  안에 있는 글이 모두 삭제 됩니다.\n그래도 삭제하시겠습니까?"
        case .deleteContent:
            return "콘텐츠를 삭제하시면 복원이 어렵습니다.\n그래도 삭제하시겠습니까?"
        case .withdrawNotice:
            return "탈퇴시 블링크에 저장한 콘텐츠 / 저장된 링크 / 폴더와 추천 키워드 / 계정 정보가 모두 삭제됩니다\n\n탈퇴 후 재가입의 경우에도 해당 데이터는 복원되지 않습니다"
        case .logout:
            return "정말 로그아웃 하시겠어요?"
        case .custom(_, let description, _, _):
            return description
        }
    }
    
    public var okText: String {
        switch self {
        case .withdrawNotice:
            return "탈퇴하기"
        case .logout:
            return "로그아웃"
        default:
            return "확인"
        }
    }
    
    public var cancelText: String {
        switch self {
        case .logout:
            return "아니오"
        default:
            return "취소"
        }
    }
}
