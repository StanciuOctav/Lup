//
//  LocationService.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import CoreLocation
import Foundation

@MainActor
final class LocationService: NSObject, ObservableObject {
    
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .denied
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        authorizationStatus = locationManager.authorizationStatus
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
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
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
} 

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.first else { return }
        userLocation = current
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationManager.stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
