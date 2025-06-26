//
//  ContentView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack{
                
            TabView(){
                HomeView()
                    .tabItem(){ Label("Home", systemImage: "house") }
                InputView()
                    .tabItem { Label("New", systemImage: "plus") }
                HistoryView()
                    .tabItem{ Label("History", systemImage: "list.bullet.below.rectangle") }
                AnalyticView()
                    .tabItem{ Label("Analytics", systemImage: "chart.bar")}
            }
        }
    }
}

#Preview {
    ContentView()
}
