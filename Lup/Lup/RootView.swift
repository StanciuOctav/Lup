//
//  RootView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Constants
import SwiftUI

enum TabSelection: Int {
    case customers
    case orders
}

struct RootView: View {
    @StateObject private var viewModel = RootViewModel(customerService: CustomerNetworkService(service: DefaultNetworkService(),
                                                                                               url: URL(string: "\(Constants.mockURL)\(Constants.getCustomersEndpoint)")!),
                                                       orderService: OrderNetworkService(service: DefaultNetworkService(),
                                                                                         url: URL(string: "\(Constants.mockURL)\(Constants.getOrdersEndpoint)")!))
    @StateObject private var locationService = LocationService()
    @StateObject private var notificationService = NotificationService()
    @StateObject private var navigationManager = NavigationManager()
    
    @State private var selectedTab: TabSelection = .customers
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CustomersView(customersSubject: viewModel.customersSubject, 
                         locationService: locationService)
                .tabItem {
                    Label(LocalizedStringKey("Customers"), systemImage: "figure.2.arms.open")
                }
                .tag(TabSelection.customers)
            
            OrdersView(ordersSubject: viewModel.ordersSubject, 
                      notificationService: notificationService,
                      navigationManager: navigationManager)
                .tabItem {
                    Label(LocalizedStringKey("Orders"), systemImage: "list.bullet")
                }
                .tag(TabSelection.orders)
        }
        .onAppear {
            viewModel.fetchData()
        }
        .onOpenURL { url in
            navigationManager.handleURL(url)
        }
        .onChange(of: navigationManager.currentRoute) { _, route in
            selectedTab = route.tab
        }
    }
}
