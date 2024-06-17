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
}

extension BKModalType {
    var isLottieNeeded: Bool {
        switch self {
        case .linkLoading:
            return true
        default:
            return false
        }
    }
    var modalTitle: String {
        switch self {
        case .linkLoading:
            return "잠시만 기다려주세요"
        case .cancelConfirm:
            return "정말 그만두시겠어요?"
        case .deleteFolder:
            return "폴더 삭제하기"
        case .deleteContent:
            return "삭제하기"
        case .custom(let titleText, _, _, _):
            return titleText
        }
    }
    
    var modalDescription: String {
        switch self {
        case .linkLoading:
            return "블링크가 눈 깜짝할 새에 요약할게요"
        case .cancelConfirm:
            return "아직 링크가 저장되지 않았어요"
        case .deleteFolder:
            return "폴더를 삭제하시면  안에 있는 글이 모두 삭제 됩니다.\n그래도 삭제하시겠습니까?"
        case .deleteContent:
            return "콘텐츠를 삭제하시면 복원이 어렵습니다.\n그래도 삭제하시겠습니까?"
        case .custom(_, let description, _, _):
            return description
        }
    }
}
