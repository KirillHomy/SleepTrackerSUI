//
//  SettingsViewModel.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//

import SwiftUI
import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var isNotificationEnabled: Bool = false {
        didSet {
            if isNotificationEnabled {
                enableNotifications()
            }
        }
    }
}

// MARK: - Private methods
private extension SettingsViewModel {

    func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications enabled")
            } else if let error = error {
                print("Notifications not enabled: \(error.localizedDescription)")
            }
        }
    }
}
