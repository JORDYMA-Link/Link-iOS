//
//  String+.swift
//  Util
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import UIKit

extension String {
    public func calculateHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return ceil(boundingRect.height)
    }
}
