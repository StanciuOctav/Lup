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
    
    init(customersPublisher: AnyPublisher<[Customer], Never>, userLocationPublisher: AnyPublisher<CLLocation?, Never>) {
        self._viewModel = StateObject(wrappedValue: MapViewModel(customersPublisher: customersPublisher, userLocationPublisher: userLocationPublisher))
    }
    
    var body: some View {
        VStack {
            ZStack {
                Map(position: $viewModel.cameraPosition) {
                    ForEach(viewModel.annotations) { annotation in
                        Annotation(annotation.customerName, coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                            Image(systemName: "figure.stand")
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(.regularMaterial).frame(width: 30, height: 30))
                                .shadow(radius: 5)
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
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button {
                            viewModel.resetRoute()
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .tint(.red)
                                .padding()
                                .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.regularMaterial))
                        }
                        .padding([.bottom, .trailing])
                    }
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu {
//                    
//                }
//            }
//        }
    }
}
