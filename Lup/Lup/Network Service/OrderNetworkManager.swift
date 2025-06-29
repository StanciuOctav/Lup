//
//  OrderNetworkService.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Constants
import Foundation

final class OrderNetworkService {
    private let service: NetworkServiceProtocol
    private let url: URL
    private var cancellables = Set<AnyCancellable>()
    
    init(service: NetworkServiceProtocol, url: URL) {
        self.service = service
        self.url = url
    }
    
    func fetchData(completion: @escaping (Result<[Order], Error>) -> Void) {
        service.fetchData(from: url, as: [Order].self)
            .sink(receiveCompletion: { status in
                if case .failure(let error) = status {
                    completion(.failure(error))
                }
            }, receiveValue: { orders in
                completion(.success(orders))
            })
            .store(in: &cancellables)
    }
}
