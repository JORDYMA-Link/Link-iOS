//
//  NotificationListView.swift
//  Blink
//
//  Created by kyuchul on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

struct NotificationListView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("NotificationList")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    LeadingItem(type: .dismiss("알림", {
                        dismiss()
                    }))
                }
            }
    }
}

#Preview {
    NotificationListView()
}
