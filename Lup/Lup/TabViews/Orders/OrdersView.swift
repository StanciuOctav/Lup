//
//  OrdersView.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Constants
import SwiftUI

struct OrdersView: View {
    
    @StateObject private var viewModel: OrdersViewModel
    
    init(ordersSubject: PassthroughSubject<[Order], Never>) {
        self._viewModel = StateObject(wrappedValue: OrdersViewModel(ordersSubject: ordersSubject))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.orders, id: \.self) { order in
                orderCardView(for: order)
            }
            .navigationTitle("Orders")
        }
    }
    
    private func orderCardView(for order: Order) -> some View {
        HStack {
            AsyncImage(url: URL(string: order.imageUrl)) { image in
                image.resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } placeholder: {
                ProgressView()
            }
            .ignoresSafeArea(.all, edges: [.top, .bottom])
                
            VStack {
                HStack {
                    Text(order.description)
                        .font(.title2)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("\(order.price)")
                    Spacer()
                    Text("\(order.status.rawValue.capitalized)")
                    Circle()
                        .foregroundStyle(order.status.statusColor)
                        .frame(maxWidth: 20, maxHeight: 20)
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .padding()
    }
}
