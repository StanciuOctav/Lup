//
//  RootViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import SwiftUI

@MainActor
final class RootViewModel: ObservableObject {
    @Published var customers: [Customer] = []
    @Published var orders: [Order] = []

    var customersSubject = PassthroughSubject<[Customer], Never>()
    var ordersSubject = PassthroughSubject<[Order], Never>()

    private let customerService: CustomerNetworkService
    private let orderService: OrderNetworkService

    init(customerService: CustomerNetworkService, orderService: OrderNetworkService) {
        self.customerService = customerService
        self.orderService = orderService
    }

    func fetchData() {
        fetchCustomers()
        fetchOrders()
    }

    private func fetchCustomers() {
        customerService.fetchData { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let customers):
                self.customersSubject.send(customers)
            case .failure(let error):
                print("Error fetching customers: \(error)")
            }
        }
    }

    private func fetchOrders() {
        orderService.fetchData { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let orders):
                self.ordersSubject.send(orders)
            case .failure(let error):
                print("Error fetching orders: \(error)")
            }
        }
    }
}
