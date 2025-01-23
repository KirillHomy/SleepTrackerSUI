//
//  HomeViewModel.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//


import Foundation
import UserNotifications
import SwiftUI

enum TimeType: String, CaseIterable {
    case day
    case week
    case month
}

struct SleepModel: Identifiable {
    let id = UUID()
    let date: Date
    let sleepDuration: TimeInterval
}

class HomeViewModel: ObservableObject {
    
    @Published var startAngel: Double = 0
    @Published var toAngel: Double = 180
    @Published var startProgress: CGFloat = 0
    @Published var toProgress: CGFloat = 0.5
    
    @Published var selectedDays: Set<String> = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @Published var isReminderEnabled: Bool = false {
        didSet {
            if isReminderEnabled {
                scheduleNotification()
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
    }
    
    let daysOfWeek: [(id: String, initial: String)] = [("Mon", "M"), ("Tue", "T"), ("Wed", "W"), ("Thu", "Th"), ("Fri", "F"), ("Sat", "S"), ("Sun", "S")]
    
    @Published var sleepModel: [SleepModel] = []
    @Published var filtredSleepModel: [SleepModel] = []
    @Published var timeType: TimeType = .week
    
    
    init() {
        generateSampleData()
        filterSleepModel()
    }
}

// MARK: - Interface methods
extension HomeViewModel {

    func getTime(angle: Double) -> Date {
        let progress = angle / 15
        let hour = Int(progress)
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        var minute = remainder * 5
        
        minute = (minute > 55 ? 55 : minute)
        
        var components = DateComponents()
        components.hour = hour == 24 ? 0 : hour
        components.minute = Int(minute)
        components.second = 0
        
        let calendar = Calendar.current
        let currentDate = Date()
        let currentDay = calendar.component(.day, from: currentDate)
        let isPastMidnight = (startAngel > toAngel) && (angle == toAngel)
        
        components.day = currentDay + (isPastMidnight ? 1 : 0)
        
        components.year = calendar.component(.year, from: currentDate)
        components.month = calendar.component(.month, from: currentDate)
        
        return calendar.date(from: components) ?? Date()
    }

    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        let progress = angle / 360
        if fromSlider {
            self.startAngel = angle
            self.startProgress = progress
        } else {
            self.toAngel = angle
            self.toProgress = progress
        }
    }

    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        let result = calendar.dateComponents([.hour, .minute], from: getTime(angle: startAngel), to: getTime(angle: toAngel))
        return (result.hour ?? 0, result.minute ?? 0)
    }

    func filterSleepModel() {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeType {
            case .day:
                filtredSleepModel = sleepModel.filter {
                    calendar.isDate($0.date, inSameDayAs: now)
                }
            case .week:
                if let weekApp = calendar.date(byAdding: .day, value: -7 ,to: now) {
                    filtredSleepModel = sleepModel.filter {
                        $0.date > weekApp && $0.date < now
                    }
                }
            case .month:
                if let monthApp = calendar.date(byAdding: .month, value: -1 ,to: now) {
                    filtredSleepModel = sleepModel.filter {
                        $0.date > monthApp && $0.date < now
                    }
                }
        }
    }
}

// MARK: - Private methods
private extension HomeViewModel {
    
    func scheduleNotification() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        
        userNotificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("print Granted")
            }  else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            self.selectedDays.forEach { day in
                let content = UNMutableNotificationContent()
                content.title = "Good Night"
                content.body = "Time to sleep at \(self.getTime(angle: self.startAngel).formatted(date: .omitted, time: .shortened))"
                content.sound = UNNotificationSound.default
                
                let components = self.getDateComponents(for: day)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
                userNotificationCenter.add(request) { error in
                   if let error = error {
                        print("Error adding notification: \(error.localizedDescription)")
                   } else {
                       print("Notification scheduled for \(day)")
                   }
                }
            }
        }
    }

    func getDateComponents(for day: String) -> DateComponents {
        var components = DateComponents()
        let startDate = getTime(angle: startAngel)
        let calendar = Calendar.current
        let notificationDate = calendar.date(byAdding: .minute, value: -30, to: startDate) ?? startDate
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notificationDate)
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        components.second = 0
        
        switch day {
            case "Sun": components.weekday = 1
            case "Mon": components.weekday = 2
            case "Tue": components.weekday = 3
            case "Wed": components.weekday = 4
            case "Thu": components.weekday = 5
            case "Fri": components.weekday = 6
            case "Sat": components.weekday = 7
            default: break
        }
        
        return components
    }

    func generateSampleData() {
        sleepModel = [
            SleepModel(date: Date().addingTimeInterval(-86400 * 6), sleepDuration: 7.0),
            SleepModel(date: Date().addingTimeInterval(-86400 * 5), sleepDuration: 6.5),
            SleepModel(date: Date().addingTimeInterval(-86400 * 4), sleepDuration: 8.0),
            SleepModel(date: Date().addingTimeInterval(-86400 * 3), sleepDuration: 7.5),
            SleepModel(date: Date().addingTimeInterval(-86400 * 2), sleepDuration: 7.8),
            SleepModel(date: Date().addingTimeInterval(-86400 * 1), sleepDuration: 7.2),
            SleepModel(date: Date(), sleepDuration: 9.0),
        ]
    }
}
