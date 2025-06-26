//
//  AnalyticView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

import SwiftUI

struct AnalyticView: View {
    
    var body: some View {
        VStack {
            LineGraph()
            Spacer()
            BarChart()
        }
    }
}

#Preview {
    AnalyticView()
}
