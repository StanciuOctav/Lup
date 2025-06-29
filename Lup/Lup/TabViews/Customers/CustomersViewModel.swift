//
//  CustomersViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import CoreLocation
import SwiftUI

@MainActor
final class CustomersViewModel: ObservableObject {
    
    @Published var customers: [Customer] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let locationService: LocationService
    
    init(customersSubject: CurrentValueSubject<[Customer], Never>, locationService: LocationService) {
        self.locationService = locationService
        
        customersSubject
            .sink { [weak self] customers in
                guard let self else { return }
                self.customers = customers
            }
            .store(in: &cancellables)
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        locationService.authorizationStatus
    }
    
    func calculateDistanceTo(latitude: Double, longitude: Double) -> String {
        locationService.calculateDistanceTo(latitude: latitude, longitude: longitude)
    }
    
    func getUserLocationPublisher() -> AnyPublisher<CLLocation?, Never> {
        locationService.getUserLocationPublisher()
    }
    
    func getCustomersPublisher() -> AnyPublisher<[Customer], Never> {
        $customers.eraseToAnyPublisher()
    }
}
