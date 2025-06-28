//
//  SortOption.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import Foundation

enum SortOption: Int, CaseIterable {
    
    case priceAscending
    case priceDiscending
    case status
    
    var description: String {
        switch self {
        case .priceAscending: "Price Ascending"
        case .priceDiscending: "Price Discending"
        case .status: "Status"
        }
    }
}
