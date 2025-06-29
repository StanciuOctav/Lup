//
//  Analytics.swift
//  Lup
//
//  Created by Octav Stanciu on 29.06.2025.
//

import Constants
import FirebaseAnalytics
import SwiftUI

protocol AnalyticsProtocol: AnyObject {
    func logEvent(_ event: Analytics.Event)
}

struct Analytics {
    private(set) static var shared = Analytics(implementation: NullAnalytics())
    
    static func setShared(with implementation: AnalyticsProtocol) {
        shared = Analytics(implementation: implementation)
    }
    
    private let implementation: AnalyticsProtocol
    
    private init(implementation: AnalyticsProtocol) {
        self.implementation = implementation
    }
    
    func logEvent(event: Event) {
        implementation.logEvent(event)
    }
}

extension Analytics {
    enum Event {
        case ordersView
        case orderDetailsView(orderId: String, orderName: String)
        case customersView
        case mapView
        case filterView
            
        case newOrder(orderId: String, orderName: String)
        case pendingOrder(orderId: String, orderName: String)
        case deliveredOrder(orderId: String, orderName: String)
    }
}

private final class NullAnalytics: AnalyticsProtocol {
    func logEvent(_ event: Analytics.Event) { }
}
