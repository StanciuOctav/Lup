//
//  RootViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import SwiftUI

final class RootViewModel: ObservableObject {
    @Published var customers: [Customer] = []
    @Published var orders: [Order] = []
    
    var customersSubject: PassthroughSubject<[Customer], Never> = .init()
    var ordersSubject: PassthroughSubject<[Order], Never> = .init()
    
    private let customerManager = CustomerNetworkManager()
    private let orderManager = OrderNetworkManager()
    
    func fetchData() async {
        await fetchCustomers()
        await fetchOrders()
    }
    
    private func fetchCustomers() async {
        await customerManager.fetchData { [weak self] results in
            guard let self else { return }
            
            switch results {
            case .success(let customers):
                Task { @MainActor in
                    self.customersSubject.send(customers)
                }
            case .failure(let failure):
                print("Failed to fetch data: \(failure)")
            }
        }
    }
    
    private func fetchOrders() async {
        await orderManager.fetchData { [weak self] results in
            guard let self else { return }
            
            switch results {
            case .success(let orders):
                Task { @MainActor in
                    self.ordersSubject.send(orders)
                }
            case .failure(let failure):
                print("Failed to fetch data: \(failure)")
            }
        }
    }
}
