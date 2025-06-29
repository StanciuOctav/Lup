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

enum RouteOptions: String, CaseIterable {
    case one, all
}

fileprivate enum BoundingBoxOption {
    case all, singleRoute
}

struct CustomerRoute: Identifiable {
    var id = UUID()
    let route: MKRoute
}

@MainActor
final class MapViewModel: ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var annotations: [CustomerAnnotation] = []
    @Published var selectedRouteOption: RouteOptions = .one
    @Published var singleRoute: MKRoute?
    @Published var routes: [CustomerRoute] = []
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
    
    func updateRoutesSelection() {
        switch selectedRouteOption {
        case .one:
            resetMultipleRoutes()
        case .all:
            resetSingleRoute()
            getAllDirections()
        }
    }
    
    func getAllDirections() {
        guard let userLocation else { return }
        
        Task { [weak self] in
            guard let self else { return }
            var newRoutes: [CustomerRoute] = []
            
            for annotation in annotations {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
                request.transportType = .walking
                
                do {
                    let directions = try await MKDirections(request: request).calculate()
                    if let direction = directions.routes.first {
                        newRoutes.append(CustomerRoute(route: direction))
                    }
                } catch {
                    print("Error updating route \(error)")
                }
            }
            
            await MainActor.run {
                self.routes = newRoutes
                self.zoomToAllCustomers()
            }
        }
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
                self?.singleRoute = directions.routes.first
                
                if let route = self?.singleRoute {
                    self?.updateRouteCameraPosition(route: route, destination: newValue.coordinate)
                }
            } catch {
                print("Error updating route \(error)")
            }
        }
    }
    
    func resetAllRoutes() {
        resetMultipleRoutes()
        resetSingleRoute()
    }
    
    func resetMultipleRoutes() {
        routes = []
        zoomToAllCustomers()
    }
    
    func resetSingleRoute() {
        singleRoute = nil
        zoomToAllCustomers()
    }
    
    private func zoomToAllCustomers() {
        guard let box = boundingBox(for: .all) else { return }
        updateCameraPosition(in: box)
    }
    
    private func updateRouteCameraPosition(route: MKRoute, destination: CLLocationCoordinate2D) {
        guard let box = boundingBox(for: .singleRoute, to: destination) else { return }
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
        case .singleRoute:
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
