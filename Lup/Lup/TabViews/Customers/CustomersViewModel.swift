//
//  CustomersViewModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import CoreLocation
import Combine
import SwiftUI

final class CustomersViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var customers: [Customer] = []
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .denied
    
    private var cancellables: Set<AnyCancellable> = []
    private let locationManager = CLLocationManager()
    
    init(customersSubject: PassthroughSubject<[Customer], Never>) {
        super.init()
        
        customersSubject
            .sink { [weak self] customers in
                guard let self else { return }
                self.customers = customers
            }
            .store(in: &cancellables)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            fallthrough
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let current = locations.first else { return }
            userLocation = current
    }
    
    func calculateDistanceTo(latitude: Double, longitude: Double) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let m = Measurement(value: userLocation?.distance(from: location) ?? 0, unit: UnitLength.meters)
        let km = m.converted(to: UnitLength.kilometers)
        let value = km.value < 1 ? m : km
        
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 2

        return formatter.string(from: value)
    }
}
