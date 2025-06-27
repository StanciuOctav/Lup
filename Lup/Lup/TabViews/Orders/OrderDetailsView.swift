//
//  OrderDetailsView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.

import SwiftUI

struct OrderDetailsView: View {
    @StateObject private var viewModel: OrderDetailsViewModel
    @Binding var order: Order
    
    init(order: Binding<Order>) {
        _viewModel = StateObject(wrappedValue: OrderDetailsViewModel(order: order))
        self._order = order
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: order.imageUrl)) { phase in
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
                        Text(order.description)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        Text("\(order.price) $")
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(order.status.rawValue.capitalized)
                        Circle()
                            .fill(order.status.statusColor)
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
                            if status != order.status {
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
        }
    }
}
