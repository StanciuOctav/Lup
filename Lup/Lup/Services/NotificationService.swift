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
    
    func sheduleUpdateOrderNotification(order: Order) {
        let content = UNMutableNotificationContent()
        content.title = "\(order.description)"
        content.body = "Order was updated"
        content.sound = .default
        
        content.userInfo = [
            "orderId": order.id,
            "deepLink": "lup://order/\(order.id)"
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OrderUpdateNotification_\(order.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Couldn't schedule a notif \(error)")
            } else {
                print("Notif scheduled")
            }
        }
    }
}
