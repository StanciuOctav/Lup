//
//  CustomersView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import SwiftUI

struct CustomersView: View {
    
    @StateObject private var viewModel: CustomersViewModel
    
    init(customersSubject: CurrentValueSubject<[Customer], Never>, locationService: LocationService) {
        _viewModel = StateObject(wrappedValue: CustomersViewModel(customersSubject: customersSubject,
                                                                  locationService: locationService))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.customers, id: \.self) { customer in
                VStack(alignment: .leading) {
                    Text(customer.name)
                    
                    if viewModel.authorizationStatus == .authorizedAlways || viewModel.authorizationStatus == .authorizedWhenInUse {
                        Text("\(viewModel.calculateDistanceTo(latitude: customer.latitude, longitude: customer.longitude)) away")
                    }
                }
            }
            .navigationTitle("Customers")
        }
    }
}
