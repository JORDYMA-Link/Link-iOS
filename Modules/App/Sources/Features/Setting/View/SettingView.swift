//
//  SettingView.swift
//  Blink
//
//  Created by kyuchul on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("SettingView")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    LeadingItem(type: .dismiss("설정", {
                        dismiss()
                    }))
                }
            }
    }
}

#Preview {
    SettingView()
}
