//
//  NotificationService.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import UserNotifications
import SwiftUI

final class NotificationService: ObservableObject {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if granted {
                print("✅ Notifications allowed")
            } else {
                print("❌ Notifications not allowed")
            }
        }
    }
    
    func scheduleNotificationForOrderUpdate(order: Order) {
        let content = UNMutableNotificationContent()
        content.title = "\(order.description)"
        content.body = "Order status was updated"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Couldn't schedule notif: \(error)")
            } else {
                print("Notif scheduled")
            }
        }
    }
}
