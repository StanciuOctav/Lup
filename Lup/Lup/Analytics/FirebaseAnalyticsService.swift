//
//  FirebaseAnalyticsService.swift
//  Lup
//
//  Created by Octav Stanciu on 29.06.2025.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsProtocol {
    func logEvent(_ event: Analytics.Event) {
        let logEvent = FirebaseAnalytics.Analytics.logEvent
        
        switch event {
        case .ordersView:
            logEvent("orders_view", [AnalyticsParameterScreenName: "OrdersView"])
        case .orderDetailsView(let orderId, let orderName):
            logEvent("order_details_view", [
                AnalyticsParameterScreenClass: "\(orderId) \(orderName)",
                AnalyticsParameterScreenName: "OrderDetailsView"])
        case .customersView:
            logEvent("customers_view", [AnalyticsParameterScreenName: "CustomersView"])
        case .mapView:
            logEvent("map_view", [AnalyticsParameterScreenName: "MapView"])
        case .filterView:
            logEvent("filter_view", [AnalyticsParameterScreenName: "FilterView"])
        case .newOrder(let orderId, let orderName):
            logEvent("order_status_changed", ["orderId": "\(orderId)", "orderName": "\(orderName)", "status": "new"])
        case .pendingOrder(let orderId, let orderName):
            logEvent("order_status_changed", ["orderId": "\(orderId)", "orderName": "\(orderName)", "status": "pending"])
        case .deliveredOrder(let orderId, let orderName):
            logEvent("order_status_changed", ["orderId": "\(orderId)", "orderName": "\(orderName)", "status": "delievered"])
        }
    }
}
