//
//  NetworkServiceProtocol.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error>
}
