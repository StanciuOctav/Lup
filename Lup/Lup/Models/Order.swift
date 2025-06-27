//
//  OrderModel.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import SwiftUI

enum OrderStatus: String, Decodable {
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
}

struct Order: Decodable, Identifiable {
    var id: Int
    var description: String
    var price: Int
    var customerId: Int
    var imageUrl: String
    var iimageUrl: URL? { URL(string: imageUrl) }
    var status: OrderStatus
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
