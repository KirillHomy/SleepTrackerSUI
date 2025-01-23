//
//  TabBarView.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//

import SwiftUI

struct TabBarView: View {

    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .onAppear {
                    selectedTabIndex = 0
                }
                .tag(0)
            
            SleepChartView()
                .tabItem {
                    Image(systemName: "moon.fill")
                    Text("Sleep")
                }
                .onAppear {
                    selectedTabIndex = 1
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .onAppear {
                    selectedTabIndex = 2
                }
                .tag(2)
        }
    }
}

#Preview {
    TabBarView()
}
