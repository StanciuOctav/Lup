//
//  AppRoute.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import Foundation

enum AppRoute: Hashable {
    case customers
    case orders
    case orderDetails(orderId: Int)
    
    var tab: TabSelection {
        switch self {
        case .customers: .customers
        case .orders, .orderDetails: .orders
        }
    }
    
    var orderId: Int? {
        switch self {
        case .orderDetails(let orderId):
            return orderId
        default:
            return nil
        }
    }
}

extension AppRoute {
    init?(from url: URL) {
        guard url.scheme == "lup" else { return nil }
        
        let pathComponents = url.pathComponents
        
        switch pathComponents.count {
        case 2:
            // lup://orders
            switch pathComponents[1] {
            case "orders":
                self = .orders
            default:
                return nil
            }
        case 3:
            // lup://order/123
            switch pathComponents[1] {
            case "order":
                guard let orderId = Int(pathComponents[2]) else { return nil }
                self = .orderDetails(orderId: orderId)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    var url: URL? {
        switch self {
        case .customers: nil
        case .orders: URL(string: "lup://orders")
        case .orderDetails(let orderId): URL(string: "lup://order/\(orderId)")
        }
    }
} 
