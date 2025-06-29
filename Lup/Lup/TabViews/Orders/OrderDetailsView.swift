//
//  OrderDetailsView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.

import SwiftUI

struct OrderDetailsView: View {
    @StateObject private var viewModel: OrderDetailsViewModel
    
    init(order: Order, onDismiss: @escaping (OrderStatus) -> Void) {
        _viewModel = StateObject(wrappedValue: OrderDetailsViewModel(order: order, onDismiss: onDismiss))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: viewModel.order.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipped()
                    } else if phase.error != nil {
                        Color.gray
                            .frame(height: 300)
                    } else {
                        ProgressView()
                            .frame(height: 300)
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                VStack {
                    HStack {
                        Text("Description")
                        Spacer()
                        Text(viewModel.order.description)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        Text("\(viewModel.order.price) $")
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(viewModel.order.status.rawValue.capitalized)
                        Circle()
                            .fill(viewModel.order.status.statusColor)
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Change order status") {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            if status != viewModel.order.status {
                                Button {
                                    viewModel.changeOrderStatusTo(status)
                                } label: {
                                    Text(status.rawValue.capitalized)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Analytics.shared.logEvent(event: .orderDetailsView(orderId: String(viewModel.order.id),
                                                                   orderName: viewModel.order.description))
            }
        }
    }
}
