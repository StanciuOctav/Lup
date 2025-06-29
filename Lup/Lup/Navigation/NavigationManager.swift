//
//  NavigationManager.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import SwiftUI
import UserNotifications

@MainActor
final class NavigationManager: NSObject, ObservableObject {
    
    @Published var currentRoute: AppRoute = .customers
    @Published var shouldNavigate = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
        
    func navigate(to route: AppRoute) {
        currentRoute = route
        shouldNavigate = true
    }
    
    func navigateToOrder(at index: Int) {
        navigate(to: .orderDetails(orderIndex: index))
    }
    
    func navigateToOrdersTab() {
        navigate(to: .orders)
    }
        
    func handleURL(_ url: URL) {
        guard let route = AppRoute(from: url) else {
            print("Invalid deepLink URL: \(url)")
            return
        }
        navigate(to: route)
    }
        
    func resetNavigation() {
        shouldNavigate = false
    }
} 

extension NavigationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let orderIndex = userInfo["orderIndex"] as? Int {
            navigateToOrder(at: orderIndex)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}
