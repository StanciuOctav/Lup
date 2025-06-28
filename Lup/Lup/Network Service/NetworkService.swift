//
//  NetworkService.swift
//  Lup
//
//  Created by Octav Stanciu on 28.06.2025.
//

import Combine
import Foundation

final class DefaultNetworkService: NetworkServiceProtocol {
    
    func fetchData<T: Decodable>(from url: URL,as type: T.Type) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      200...299 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
