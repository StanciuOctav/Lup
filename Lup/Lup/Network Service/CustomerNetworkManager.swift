//
//  CustomerNetworkService.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Constants
import Foundation

final class CustomerNetworkService {
    private let service: NetworkServiceProtocol
    private let url: URL
    private var cancellables = Set<AnyCancellable>()
    
    init(service: NetworkServiceProtocol, url: URL) {
        self.service = service
        self.url = url
    }
    
    func fetchData(completion: @escaping (Result<[Customer], Error>) -> Void) {
        service.fetchData(from: url, as: [Customer].self)
            .sink(receiveCompletion: { status in
                if case .failure(let error) = status {
                    completion(.failure(error))
                }
            }, receiveValue: { customers in
                completion(.success(customers))
            })
            .store(in: &cancellables)
    }
}
