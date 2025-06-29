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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { didGrant, error in
            if let error {
                print("Notifications authorization error: \(error)")
            } else {
                print("Granted")
            }
        }
    }
    
    func sheduleUpdateOrderNotification(description: String, orderIndex: Int) {
        let content = UNMutableNotificationContent()
        content.title = "\(description)"
        content.body = "Order was updated"
        content.sound = .default
        
        content.userInfo = [
            "orderIndex": orderIndex,
            "deepLink": "lup://order/\(orderIndex)"
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OrderUpdateNotification_\(orderIndex)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Couldn't schedule a notif \(error)")
            } else {
                print("Notif scheduled")
            }
        }
    }
}
