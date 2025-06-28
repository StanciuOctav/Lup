//
//  ContentViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import SwiftUI

final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private var selectedOrderIndex: Int?
    
    private var cancellables: Set<AnyCancellable> = []

    init(ordersSubject: CurrentValueSubject<[Order], Never>) {
        ordersSubject
            .sink { [weak self] orders in
                guard let self else { return }
                self.orders = orders
            }
            .store(in: &cancellables)
    }
    
    func updateOrderStatus(_ newStatus: OrderStatus) {
        if let selectedOrderIndex {
            orders[selectedOrderIndex].status = newStatus
        }
    }
    
    func updateSelectedIndex(order: Order) {
        selectedOrderIndex = orders.firstIndex(where: { $0 == order })
    }
}
