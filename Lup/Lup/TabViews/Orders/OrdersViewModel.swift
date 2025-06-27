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
    
    private var cancellables: Set<AnyCancellable> = []

    init(ordersSubject: PassthroughSubject<[Order], Never>) {
        ordersSubject
            .sink { [weak self] orders in
                guard let self else { return }
                self.orders = orders
            }
            .store(in: &cancellables)
    }
    
    func bindingFor(order: Order) -> Binding<Order>? {
        guard  let index = orders.firstIndex(of: order) else { return nil }
        return Binding {
            self.orders[index]
        } set: {
            self.orders[index] = $0
        }
    }
}
