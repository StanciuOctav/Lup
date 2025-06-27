//
//  OrderNetworkManager.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

import Combine
import Constants
import Foundation

final class OrderNetworkManager: NetworkServiceProtocol {
    typealias T = Order
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchData(completion: @escaping (Result<[T], any Error>) -> Void) async {
        guard let url = URL(string: requestDataURL()) else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryCompactMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(URLError(.badServerResponse)))
                    return nil
                }
                return data
            }
            .decode(type: [T].self, decoder: decoder)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { status in
                switch status {
                case .finished:
                    print("Completed")
                    break
                case .failure(let error):
                    print("Receiver error \(error)")
                    completion(.failure(error))
                    break
                }
            }, receiveValue: { customers in
                completion(.success(customers))
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func requestDataURL() -> String {
        return "\(Constants.mockURL)\(Constants.getOrdersEndpoint)"
    }
}
