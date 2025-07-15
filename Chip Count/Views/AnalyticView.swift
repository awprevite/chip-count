//
//  AnalyticView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

import SwiftUI
import Charts

struct AnalyticView: View {
    
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = AnalyticViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    LineGraph(cumulativeEntries: viewModel.cumulativeEntries)
                        .frame(height: 400)
                        .padding()
                    
                    BarChart(
                        selectedGroupBy: $viewModel.selectedGroupBy,
                        selectedMetric: $viewModel.selectedMetric,
                        averagedEntries: viewModel.averagedEntries
                    )
                    .frame(height: 400)
                    .padding()
                }
                .onAppear {
                    viewModel.fetchAllSessions(context: context)
                }
                .navigationTitle("Analytics")
            }
        }
    }
}

struct BarChart: View {
    
    @Binding var selectedGroupBy: AnalyticViewModel.GroupBy
    @Binding var selectedMetric: AnalyticViewModel.Metric
    let averagedEntries: [AnalyticViewModel.BarEntry]

    var body: some View {
        VStack {
            Text("Comparison by Location and Time")
            Picker("Metric", selection: $selectedMetric) {
                ForEach(AnalyticViewModel.Metric.allCases, id: \.self) { metric in
                    Text(metric.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Chart {
                ForEach(averagedEntries) { entry in
                    BarMark(
                        x: .value("Group", entry.groupName),
                        y: .value("Average", entry.average)
                    )
                    .foregroundStyle(by: .value("Metric", entry.metricName))
                }
            }
            .padding()
            
            Picker("Group By", selection: $selectedGroupBy) {
                ForEach(AnalyticViewModel.GroupBy.allCases, id: \.self) { groupBy in
                    Text(groupBy.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct LineGraph: View {
    
    let cumulativeEntries: [AnalyticViewModel.LineEntry]
    
    var body: some View {
        VStack{
            Text("Profit Over Time")
            
            Chart {
                ForEach(cumulativeEntries) { entry in
                    LineMark(x: .value("Date", entry.date), y: .value("Profit", entry.cumulativeProfit))
                    PointMark(x: .value("Date", entry.date), y: .value("Profit", entry.cumulativeProfit))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartXScale(range: .plotDimension(padding: 10))
            .chartYAxis {
                AxisMarks{
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
    }
}

struct HeatCalendar: View {
    
    @ObservedObject var viewModel: AnalyticViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    var body: some View {
        Text("S")
    }
    
}

#Preview {
    AnalyticView()
}
