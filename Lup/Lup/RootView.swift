//
//  RootView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Constants
import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel(customerService: CustomerNetworkService(service: DefaultNetworkService(),
                                                                                               url: URL(string: "\(Constants.mockURL)\(Constants.getCustomersEndpoint)")!),
                                                       orderService: OrderNetworkService(service: DefaultNetworkService(),
                                                                                         url: URL(string: "\(Constants.mockURL)\(Constants.getOrdersEndpoint)")!))
    
    var body: some View {
        TabView {
            OrdersView(ordersSubject: viewModel.ordersSubject)
                .tabItem {
                    Label(LocalizedStringKey("Orders"), systemImage: "list.bullet")
                }
            CustomersView(customersSubject: viewModel.customersSubject)
                .tabItem {
                    Label(LocalizedStringKey("Customers"), systemImage: "figure.2.arms.open")
                }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}
