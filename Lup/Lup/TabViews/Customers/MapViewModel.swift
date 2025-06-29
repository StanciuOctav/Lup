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

fileprivate struct BoundingBox {
    let minLat: Double
    let maxLat: Double
    let minLon: Double
    let maxLon: Double
    
    var latPadding: Double {
        (maxLat - minLat) * 0.3
    }
    
    var lonPadding: Double {
        (maxLon - minLon) * 0.3
    }
}

fileprivate enum BoundingBoxOption {
    case all, route
}

@MainActor
final class MapViewModel: ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var annotations: [CustomerAnnotation] = []
    @Published var route: MKRoute?
    @Published var cameraPosition: MapCameraPosition = .automatic
    
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
                
                if let route = self?.route {
                    self?.updateRouteCameraPosition(route: route, destination: newValue.coordinate)
                }
            } catch {
                print("Error updating route \(error)")
            }
        }
    }
    
    func resetRoute() {
        route = nil
        zoomToAllCustomers()
    }
    
    private func zoomToAllCustomers() {
        guard let box = boundingBox(for: .all) else { return }
        updateCameraPosition(in: box)
    }
    
    private func updateRouteCameraPosition(route: MKRoute, destination: CLLocationCoordinate2D) {
        guard let box = boundingBox(for: .route, to: destination) else { return }
        updateCameraPosition(in: box)
    }
    
    private func updateCameraPosition(in box: BoundingBox) {
        let center = CLLocationCoordinate2D(latitude: (box.minLat + box.maxLat) / 2, longitude: (box.minLon + box.maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (box.maxLat - box.minLat) + box.latPadding, longitudeDelta: (box.maxLon - box.minLon) + box.lonPadding)
        let region = MKCoordinateRegion(center: center, span: span)
        
        withAnimation {
            cameraPosition = .region(region)
        }
    }
    
    private func boundingBox(for option: BoundingBoxOption, to destination: CLLocationCoordinate2D? = nil) -> BoundingBox? {
        switch(option) {
        case .all:
            guard !annotations.isEmpty else { return nil }
            let latitudes = annotations.map { $0.latitude }
            let longitudes = annotations.map { $0.longitude }
            return BoundingBox(minLat: latitudes.min() ?? 0,
                               maxLat: latitudes.max() ?? 0,
                               minLon: longitudes.min() ?? 0,
                               maxLon: longitudes.max() ?? 0)
        case .route:
            guard let userCoordinate = userLocation?.coordinate,
            let destination else { return nil }
            return BoundingBox(minLat: min(userCoordinate.latitude, destination.latitude),
                               maxLat: max(userCoordinate.latitude, destination.latitude),
                               minLon: min(userCoordinate.longitude, destination.longitude),
                               maxLon: max(userCoordinate.longitude, destination.longitude))
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
