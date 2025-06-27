//
//  ContentViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var customers: [Customer] = []
    @Published var orders: [Order] = []
    private let customerManager = CustomerNetworkManager()
    private let orderManager = OrderNetworkManager()
    
    func fetchCustomers() async {
        await customerManager.fetchData { [weak self] results in
            guard let self else { return }

            switch results {
            case .success(let customers):
                Task { @MainActor in
                    self.customers = customers
                }
            case .failure(let failure):
                print("Failed to fetch data: \(failure)")
            }
        }
    }
    
    func fetchOrders() async {
        await orderManager.fetchData { [weak self] results in
            guard let self else { return }

            switch results {
            case .success(let orders):
                Task { @MainActor in
                    self.orders = orders
                }
            case .failure(let failure):
                print("Failed to fetch data: \(failure)")
            }
        }
    }
}
