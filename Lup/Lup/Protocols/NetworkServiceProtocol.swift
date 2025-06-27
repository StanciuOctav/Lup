//
//  NetworkServiceProtocol.swift
//  Lup
//
//  Created by Octav Stanciu on 27.06.2025.
//

protocol NetworkServiceProtocol<T> {
    associatedtype T: Decodable
    
    func fetchData(completion: @escaping (Result<[T], Error>) -> Void) async
}
