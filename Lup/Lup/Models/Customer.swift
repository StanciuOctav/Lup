//
//  Customer.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

struct Customer: Decodable, Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
}
