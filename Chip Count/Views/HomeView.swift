//
//  HomeView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

// Could implement records - viewable by friends, would require external back-end set up

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Text("Placeholder") 
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Net Profit")
                    .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                
                Text(viewModel.totalProfitString)
                    .modifier(LargeTextStyle(color:
                                                viewModel.totalProfit == 0 ? Color("ForegroundColor") : (viewModel.totalProfit > 0 ? .green : .red)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding()
                
                Divider()
                    .modifier(PrimaryDividerStyle())
                
                VStack(alignment: .leading) {
                    
                    Text("Total Sessions")
                        .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                    
                    Text("\(viewModel.numSessionsString)")
                        .modifier(LargeTextStyle(color: Color("ForegroundColor")))
                    
                    Text("Time Played")
                        .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                    
                    Text("\(viewModel.totalDurationString)")
                        .modifier(LargeTextStyle(color: Color("ForegroundColor")))
                    
                    Text("Average Duration")
                        .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                    
                         Text("\(viewModel.avgDurationString)")
                        .modifier(LargeTextStyle(color: Color("ForegroundColor")))
                    
                    Text("Average Profit")
                        .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                    
                         Text("\(viewModel.hourlyProfitString)")
                        .modifier(LargeTextStyle(color: Color("ForegroundColor")))
                    
                    Text("Hourly Rate")
                        .modifier(SmallTextStyle(color: Color("ForegroundColor")))
                    
                         Text("\(viewModel.avgProfitString)")
                        .modifier(LargeTextStyle(color: Color("ForegroundColor")))
                    
                }
                .frame(maxWidth: 325, alignment: .leading)
            }
        }
        .onAppear {
            viewModel.loadSessions(context: context)
        }
    }
}

#Preview {
    HomeView()
}
