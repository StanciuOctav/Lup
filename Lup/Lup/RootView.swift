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
    @StateObject private var locationService = LocationService()
    
    var body: some View {
        TabView {
            CustomersView(customersSubject: viewModel.customersSubject, locationService: locationService)
                .tabItem {
                    Label(LocalizedStringKey("Customers"), systemImage: "figure.2.arms.open")
                }
            OrdersView(ordersSubject: viewModel.ordersSubject)
                .tabItem {
                    Label(LocalizedStringKey("Orders"), systemImage: "list.bullet")
                }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
