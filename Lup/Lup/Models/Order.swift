//
//  OrderModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import SwiftUI

enum OrderStatus: String, CaseIterable, Decodable {
    case new, pending, delivered
    
    var statusColor: Color {
        switch self {
        case .new:
                .gray
        case .pending:
                .orange
        case .delivered:
                .green
        }
    }
    
    var sortValue: Int {
        switch self {
        case .new:
            1
        case .pending:
            2
        case .delivered:
            3
        }
    }
}

struct Order: Decodable, Identifiable {
    var id: Int
    var description: String
    var price: Int
    var customerId: Int
    var imageUrl: String
    var status: OrderStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case price
        case customerId = "customer_id"
        case imageUrl = "image_url"
        case status
    }
}

extension Order: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
        hasher.combine(price)
        hasher.combine(customerId)
        hasher.combine(imageUrl)
        hasher.combine(status)
    }
}

extension Order: Equatable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id &&
        lhs.description == rhs.description &&
        lhs.price == rhs.price &&
        lhs.customerId == rhs.customerId &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.status == rhs.status
    }
}
