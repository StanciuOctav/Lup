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
    
    @ObservedObject var navigationManager: NavigationManager
    @StateObject private var viewModel: OrdersViewModel
    @State private var navigationPath: [Order] = []
    @State private var isFilteringSheetPresented: Bool = false
    
    init(ordersSubject: CurrentValueSubject<[Order], Never>, 
         notificationService: NotificationService,
         navigationManager: NavigationManager) {
        self._viewModel = StateObject(wrappedValue: OrdersViewModel(ordersSubject: ordersSubject,
                                                                   notificationService: notificationService))
        self.navigationManager = navigationManager
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath, root: {
            List(viewModel.filteredOrders, id: \.self) { order in
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
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search orders...")
            .onChange(of: viewModel.searchText, { _, newValue in
                viewModel.updateSearchText(with: newValue)
            })
            .navigationTitle("Orders")
            .navigationDestination(for: Order.self) { order in
                OrderDetailsView(order: order) { newStatus in
                    viewModel.updateOrderStatus(for: order, with: newStatus)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { sortOption in
                            Button {
                                viewModel.updateSortOption(sortOption)
                            } label: {
                                HStack {
                                    Text(sortOption.description)
                                    if sortOption == viewModel.sortOption {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isFilteringSheetPresented = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        })
        .sheet(isPresented: $isFilteringSheetPresented, content: {
            FiltersView(filterConfigurator: viewModel.filterConfigurator,
                        customersIds: viewModel.customersIds)
        })
        .onChange(of: navigationManager.shouldNavigate) { _, shouldNavigate in
            if shouldNavigate {
                handleNavigation()
                navigationManager.resetNavigation()
            }
        }
    }
    
    private func handleNavigation() {
        let route = navigationManager.currentRoute
        
        switch route {
        case .orderDetails(let orderIndex):
            navigateToOrder(at: orderIndex)
        case .orders:
            // Deja aici, nu avem unde sa facem navigare
            break
        default:
            break
        }
    }
    
    private func navigateToOrder(at index: Int) {
        guard index >= 0 && index < viewModel.orders.count else { return }
        
        let order = viewModel.orders[index]
        navigationPath.append(order)
    }
}
