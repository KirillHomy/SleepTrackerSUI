//
//  SleepChartView.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//

import SwiftUI
import Charts

struct SleepChartView: View {
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Time View", selection: $homeViewModel.timeType) {
                    ForEach(TimeType.allCases, id: \.self) {
                        timeView in
                        Text(timeView.rawValue).tag(timeView)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: homeViewModel.timeType) {
                    homeViewModel.filterSleepModel()
                }
                
                Chart {
                    RuleMark(y: .value("Goal", 7.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    
                    ForEach(homeViewModel.filtredSleepModel) {
                        data in
                        BarMark(x: .value("Date", data.date, unit: .day),
                                y: .value("Sleep Duration", data.sleepDuration)
                        )
                        .foregroundStyle(.blue.gradient)
                    }
                }
                .frame(height: 300)
                .chartYScale(domain: 0...8)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Sleep Duration")
        }
    }
}

#Preview {
    SleepChartView()
}
