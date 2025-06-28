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
    private var notificationService: NotificationService
    
    private var cancellables: Set<AnyCancellable> = []

    init(ordersSubject: CurrentValueSubject<[Order], Never>, notificationService: NotificationService) {
        self.notificationService = notificationService

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
            notificationService.sheduleUpdateOrderNotification(description: orders[selectedOrderIndex].description,
                                                               orderIndex: selectedOrderIndex)
        }
    }
    
    func updateSelectedIndex(order: Order) {
        selectedOrderIndex = orders.firstIndex(where: { $0 == order })
    }
}
