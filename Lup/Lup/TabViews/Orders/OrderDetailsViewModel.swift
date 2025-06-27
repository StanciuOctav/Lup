//
//  OrderDetailsViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import SwiftUI

final class OrderDetailsViewModel: ObservableObject {
    @Binding var order: Order

    init(order: Binding<Order>) {
        self._order = order
    }
    
    func changeOrderStatusTo(_ status: OrderStatus) {
        order.status = status
    }
}
