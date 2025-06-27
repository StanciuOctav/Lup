//
//  ContentView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Constants
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.customers, id: \.id) { customer in
                Text(customer.name)
            }
            ForEach(viewModel.orders, id: \.id) { order in
                Text(order.description)
            }
        }
        .padding()
        .task {
//            await viewModel.fetchCustomers()
            await viewModel.fetchOrders()
        }
    }
}

#Preview {
    ContentView()
}
