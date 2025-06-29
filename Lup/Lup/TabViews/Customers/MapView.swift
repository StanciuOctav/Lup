//
//  MapView.swift
//  Lup
//
//  Created by Octav Stanciu on 29.06.2025.
//

import Combine
import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    init(customersPublisher: AnyPublisher<[Customer], Never>, userLocationPublisher: AnyPublisher<CLLocation?, Never>) {
        self._viewModel = StateObject(wrappedValue: MapViewModel(customersPublisher: customersPublisher, userLocationPublisher: userLocationPublisher))
    }
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(viewModel.annotations) { annotation in
                    Annotation(annotation.customerName, coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                        Image(systemName: "figure.stand")
                            .background(Circle().fill(.white).frame(width: 30, height: 30))
                            .contextMenu {
                                Button("Navigate to \(annotation.customerName)", systemImage: "arrow.turn.right.up") {
                                    viewModel.getDirections(to: annotation)
                                }
                            }
                    }
                }
                UserAnnotation()
                
                if let route = viewModel.route {
                    MapPolyline(route)
                            .stroke(Color.blue, lineWidth: 3)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
        }
    }
}
