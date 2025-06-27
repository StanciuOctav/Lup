//
//  OrderModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

enum OrderStatus: String, Decodable {
    case new, pending, delivered
}

struct Order: Decodable, Identifiable {
    var id: Int
    var description: String
    var price: Int
    var customerId: Int
    var imageUrl: String
    var status: OrderStatus
}
