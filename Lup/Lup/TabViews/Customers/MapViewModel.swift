//
//  MapViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 29.06.2025.
//

import Combine
import CoreLocation
import MapKit
import SwiftUI

struct CustomerAnnotation: Identifiable {
    var id = UUID()
    let customerName: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
}

@MainActor
final class MapViewModel: ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var annotations: [CustomerAnnotation] = []
    @Published var route: MKRoute?
    private var customers: [Customer] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(customersPublisher: AnyPublisher<[Customer], Never>, userLocationPublisher: AnyPublisher<CLLocation?, Never>) {
        customersPublisher
            .sink { [weak self] customers in
                self?.customers = customers
                self?.updateAnnotations(from: customers)
            }
            .store(in: &cancellables)
        
        userLocationPublisher
            .sink { [weak self] location in
                self?.userLocation = location
            }
            .store(in: &cancellables)
    }
    
    func getDirections(to newValue: CustomerAnnotation) {
        guard let userLocation else { return }
        
        Task { [weak self] in
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: newValue.coordinate))
            request.transportType = .walking
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                self?.route = directions.routes.first
            } catch {
                print("Error updating route \(error)")
            }
        }
    }
    
    private func updateAnnotations(from customers: [Customer]) {
        self.annotations = customers.map { customer in
            CustomerAnnotation(
                customerName: customer.name,
                latitude: customer.latitude,
                longitude: customer.longitude
            )
        }
    }
}
