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
    
    init(ordersSubject: CurrentValueSubject<[Order], Never>) {
        self._viewModel = StateObject(wrappedValue: OrdersViewModel(ordersSubject: ordersSubject))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath, root: {
            List(viewModel.orders, id: \.self) { order in
                NavigationLink(value: order) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(order.description)
                                .font(.title2)
                            Text("\(order.price)$")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        HStack {
                            Text(order.status.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Circle()
                                .fill(order.status.statusColor)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Order.self) { order in
                OrderDetailsView(order: order) { newStatus in
                    viewModel.updateSelectedIndex(order: order)
                    viewModel.updateOrderStatus(newStatus)
                }
            }
        })
    }
}
