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
    @Published var filteredOrders: [Order] = []
    @Published var sortOption: SortOption = .priceAscending
    @Published var searchText: String = ""
    private var notificationService: NotificationService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(ordersSubject: CurrentValueSubject<[Order], Never>, notificationService: NotificationService) {
        self.notificationService = notificationService
        
        ordersSubject
            .sink { [weak self] orders in
                guard let self else { return }
                self.orders = orders
                self.applySearchAndFilters()
            }
            .store(in: &cancellables)
    }
    
    func updateOrderStatus(for order: Order, with newStatus: OrderStatus) {
        if let selectedOrderIndex = orders.firstIndex(where: { $0 == order }) {
            orders[selectedOrderIndex].status = newStatus
            notificationService.sheduleUpdateOrderNotification(description: orders[selectedOrderIndex].description,
                                                               orderIndex: selectedOrderIndex)
            filteredOrders = orders
            applySearchAndFilters()
        }
    }
}

extension OrdersViewModel {
    func updateSearchText(with newValue: String) {
        searchText = newValue
        applySearchAndFilters()
    }
}

extension OrdersViewModel {
    
    func updateSortOption(_ sortOption: SortOption) {
        self.sortOption = sortOption
        applySearchAndFilters()
    }
    
    func resetOrders() {
        filteredOrders = orders
    }
    
    private func applySearchAndFilters() {
        var filtered = orders
        
        if !searchText.isEmpty {
            filtered = orders.filter({ $0.description.lowercased().contains(searchText.lowercased()) })
        }
        
        self.sortOption = sortOption
        switch sortOption {
        case .priceAscending:
            filtered = filtered.sorted { $0.price < $1.price }
        case .priceDiscending:
            filtered = filtered.sorted { $0.price > $1.price }
        case .status:
            filtered = filtered.sorted { $0.status.sortValue < $1.status.sortValue }
        }
        
        filteredOrders = filtered
    }
}
