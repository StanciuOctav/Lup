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
    }
}
