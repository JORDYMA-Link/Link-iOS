//
//  CalendarView.swift
//  Features
//
//  Created by 문정호 on 6/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct CalendarView: View {
  let store: StoreOf<CalendarFeature>
  
    var body: some View {
      VStack(alignment: .leading) {
        GeometryReader(content: { geometry in
          
          BKCalendarView(calendarStore: store)
            .frame(height: geometry.size.height/2)
          
          EmptyView()
            .background(Color.red)
        })
        
      }
    }
}

#Preview {
  CalendarView(store: Store(initialState: CalendarFeature.State(), reducer: {
    CalendarFeature()
  }))
}
