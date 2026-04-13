//
//  Folder+FolderItem.swift
//  Feature
//
//  Created by kyuchul on 2024.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import BKModel
import BKDesignSystem

extension Folder: FolderItem {
  public var folderName: String {
    return self.name
  }
}
