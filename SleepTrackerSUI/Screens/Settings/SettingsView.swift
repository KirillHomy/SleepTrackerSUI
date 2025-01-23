//
//  SettingsView.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State var hours: Int = 0
    @State var minuts: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    TextField("UserName", text: $settingsViewModel.userName)
                    TextField("Email", text: $settingsViewModel.email)
                    Toggle("Enable notifications", isOn: $settingsViewModel.isNotificationEnabled)
                }
                
                Section(header: Text("Sleeping")) {
                    NavigationLink("Sleep Duration", destination: SleepChartView())
                    Text("Achievements")
                    HStack {
                        Picker("My Goal", selection: $hours) {
                            ForEach(1..<12, id: \.self) { hour in
                                Text("\(hour) hours").tag(hour)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        
                        Picker("", selection: $minuts) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute) minutes").tag(minute)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .frame(minWidth: 80)
                    }
                }
                
                Section(header: Text("General")) {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
