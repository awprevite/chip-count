//
//  ContentView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationStack{
                
                ZStack {
                    
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Net Profit")
                            .modifier(SmallTextStyle(color: .white))
                        
                        Text(String(format: "$%.2f", viewModel.totalProfit))
                            .modifier(LargeTextStyle(color:
                                viewModel.totalProfit == 0 ? .white : (viewModel.totalProfit > 0 ? .green : .red)))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .padding()
                        
                        Divider()
                            .frame(width: 350)
                            .frame(height: 2)
                            .background(Color.white)
                            .padding(.vertical, 8)
                        
                        VStack(alignment: .leading) {
                            
                            Text("Total Sessions")
                                .modifier(SmallTextStyle(color: .white))
                            
                            Text("\(viewModel.totalSessions)")
                                .modifier(LargeTextStyle(color: .white))
                            
                            Text("Time Played")
                                .modifier(SmallTextStyle(color: .white))
                            
                            Text(String(format: "%d:%02d", viewModel.totalTime / 60, viewModel.totalTime % 60))
                                .modifier(LargeTextStyle(color: .white))
                            
                            Text("Hourly Rate")
                                .modifier(SmallTextStyle(color: .white))
                            
                            Text(String(format: "$%.2f", viewModel.hourlyRate))
                            
                            Text("Average Duration")
                                .modifier(SmallTextStyle(color: .white))
                            
                            Text("\(viewModel.averageDuration)")
                                .modifier(LargeTextStyle(color: .white))
                            
                            Text("Average Profit")
                                .modifier(SmallTextStyle(color: .white))
                            
                            Text(String(format: "$%.2f", viewModel.averageProfit))
                                .modifier(LargeTextStyle(color: .white))
                            
                        }
                        .frame(maxWidth: 325, alignment: .leading)
                        
                        Spacer()
                        
                        Divider()
                            .frame(width: 350)
                            .frame(height: 2)
                            .background(Color.white)
                            .padding(.vertical, 8)
                        
                        Spacer()
                        
                        NavigationLink(destination: InputView()){
                            Text("New Session")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Spacer()
                        
                        NavigationLink(destination: HistoryView()){
                            Text("View History")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Spacer()
                        
                    }
                    .onAppear {
                        viewModel.loadSessions(context: viewContext)
                    }
                }
            }
            .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    ContentView()
}
