//
//  OrderDetailsViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import SwiftUI

final class OrderDetailsViewModel: ObservableObject {
    @Published var order: Order
    let onDismiss: (OrderStatus) -> Void

    init(order: Order, onDismiss: @escaping (OrderStatus) -> Void) {
        self.order = order
        self.onDismiss = onDismiss
    }
    
    func changeOrderStatusTo(_ status: OrderStatus) {
        order.status = status
        onDismiss(status)
        logAnalyticsEvent(status)
    }
}

extension OrderDetailsViewModel {
    private func logAnalyticsEvent(_ status: OrderStatus) {
        let id = order.id
        let name = order.description
        
        switch status {
        case .new:
            Analytics.shared.logEvent(event: .newOrder(orderId: String(id), orderName: name))
        case .pending:
            Analytics.shared.logEvent(event: .pendingOrder(orderId: String(id), orderName: name))
        case .delivered:
            Analytics.shared.logEvent(event: .deliveredOrder(orderId: String(id), orderName: name))
        }
    }
}
