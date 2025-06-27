//
//  OrdersView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Constants
import SwiftUI

struct OrdersView: View {
    
    @StateObject private var viewModel: OrdersViewModel
    @State private var navigationPath: [Order] = []
    
    init(ordersSubject: PassthroughSubject<[Order], Never>) {
        self._viewModel = StateObject(wrappedValue: OrdersViewModel(ordersSubject: ordersSubject))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath, root: {
            List(viewModel.orders, id: \.self) { order in
                NavigationLink(value: order) {
                    HStack {
                        Text(order.description)
                            .font(.title2)
                        Text("\(order.price)$")
                    }
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Order.self) { order in
                if let binding = viewModel.bindingFor(order: order) {
                    OrderDetailsView(order: binding)
                } else {
                    Text("No order found")
                }
            }
        })
    }
}
