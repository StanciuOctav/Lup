//
//  FiltersView.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import SwiftUI

struct FiltersView: View {
    
    @ObservedObject var filterConfigurator: FiltersConfigurator
    let customersIds: [Int]
    @Environment(\.dismiss) private var dismiss
    
    @State private var minPriceText: String = ""
    @State private var maxPriceText: String = ""
    @State private var selectedStatus: OrderStatus?
    @State private var selectedCustomerId: Int?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Status Filter") {
                    Picker("Status", selection: $selectedStatus) {
                        Text("All Statuses").tag(nil as OrderStatus?)
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized).tag(status as OrderStatus?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Price Range") {
                    HStack {
                        TextField("Min Price", text: $minPriceText)
                            .keyboardType(.numberPad)
                        TextField("Max Price", text: $maxPriceText)
                            .keyboardType(.numberPad)
                    }
                    
                    Button("Clear Price Range") {
                        minPriceText = ""
                        maxPriceText = ""
                    }
                }
                
                Section("Customer Filter") {
                    Picker("Customer", selection: $selectedCustomerId) {
                        Text("All Customers").tag(nil as Int?)
                        ForEach(customersIds, id: \.self) { customerId in
                            Text("Customer \(customerId)").tag(customerId as Int?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button("Clear All Filters") {
                        selectedStatus = nil
                        minPriceText = ""
                        maxPriceText = ""
                        selectedCustomerId = nil
                        filterConfigurator.clearAllFilters()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        applyFilters()
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedStatus = filterConfigurator.selectedStatusFilter
                selectedCustomerId = filterConfigurator.selectedCustomerId
                
                if filterConfigurator.minPrice > 0 {
                    minPriceText = String(Int(filterConfigurator.minPrice))
                }
                if filterConfigurator.maxPrice < Double.infinity {
                    maxPriceText = String(Int(filterConfigurator.maxPrice))
                }
            }
        }
    }
    
    private func applyFilters() {
        filterConfigurator.selectedStatusFilter = selectedStatus
        
        let minPriceValue = Double(minPriceText) ?? 0
        let maxPriceValue = Double(maxPriceText) ?? Double.infinity
        
        filterConfigurator.minPrice = minPriceValue
        filterConfigurator.maxPrice = maxPriceValue
        
        filterConfigurator.selectedCustomerId = selectedCustomerId
    }
}
