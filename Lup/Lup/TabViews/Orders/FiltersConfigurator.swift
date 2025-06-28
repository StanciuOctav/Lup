//
//  FiltersConfigurator.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import SwiftUI

final class FiltersConfigurator: ObservableObject {
    @Published var selectedStatusFilter: OrderStatus?
    @Published var minPrice: Double = 0
    @Published var maxPrice: Double = Double.infinity
    @Published var selectedCustomerId: Int?
    
    func clearAllFilters() {
        selectedStatusFilter = nil
        minPrice = 0
        maxPrice = Double.infinity
        selectedCustomerId = nil
    }
    
    func applyFilters(to orders: [Order]) -> [Order] {
        var filtered = orders
        
        if let statusFilter = selectedStatusFilter {
            filtered = filtered.filter { $0.status == statusFilter }
        }
        
        if minPrice > 0 || maxPrice < Double.infinity {
            filtered = filtered.filter { order in
                let price = Double(order.price)
                return price >= minPrice && price <= maxPrice
            }
        }
        
        if let customerId = selectedCustomerId {
            filtered = filtered.filter { $0.customerId == customerId }
        }
        
        return filtered
    }
}
