//
//  HomeView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

// Could implement records - viewable by friends, would require external back-end set up

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Text("Placeholder")
            
            //            Color("BackgroundColor")
            //                .ignoresSafeArea()
            //            
            //            VStack {
            //                
            //                Text("Net Profit")
            //                    .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                
            //                Text(String(format: "$%.2f", viewModel.totalProfit))
            //                    .modifier(LargeTextStyle(color:
            //                                                viewModel.totalProfit == 0 ? Color("PrimaryColor") : (viewModel.totalProfit > 0 ? .green : .red)))
            //                    .lineLimit(1)
            //                    .minimumScaleFactor(0.3)
            //                    .padding()
            //                
            //                Divider()
            //                    .modifier(PrimaryDividerStyle())
            //                
            //                VStack(alignment: .leading) {
            //                    
            //                    Text("Total Sessions")
            //                        .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("\(viewModel.totalSessions)")
            //                        .modifier(LargeTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("Time Played")
            //                        .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text(String(format: "%d:%02d", viewModel.totalTime / 60, viewModel.totalTime % 60))
            //                        .modifier(LargeTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("Hourly Rate")
            //                        .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text(String(format: "$%.2f", viewModel.hourlyRate))
            //                        .modifier(LargeTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("Average Duration")
            //                        .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("\(viewModel.averageDuration)")
            //                        .modifier(LargeTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text("Average Profit")
            //                        .modifier(SmallTextStyle(color: Color("PrimaryColor")))
            //                    
            //                    Text(String(format: "$%.2f", viewModel.averageProfit))
            //                        .modifier(LargeTextStyle(color: Color("PrimaryColor")))
            //                    
            //                }
            //                .frame(maxWidth: 325, alignment: .leading)
            //                
            //                Divider()
            //                    .modifier(PrimaryDividerStyle())
            //            }
            //        }
        }
    }
}

#Preview {
    HomeView()
}
