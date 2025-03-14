//
//  NetworkManager.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation

protocol Networking {
    var urlString: String {get}
    func downloadingData(completion: @escaping (Result<[Todo], NetworkingError>) -> Void)
}

enum NetworkingError: LocalizedError {
    case badUrl
    case badURLResponse(url: URL)
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badUrl: return "[⚠️] Bad URL"
        case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
        case .decodingError: return "[⚠️] Error decoding JSON"
        case .unknown: return "[⚠️] Unknown error"
        }
    }
}

final class NetworkManager: Networking {
    let urlString = "https://dummyjson.com/todos"
    
    func downloadingData(completion: @escaping (Result<[Todo], NetworkingError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badUrl))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                if let error {
                    print("dataTask error: \(error.localizedDescription)")
                    completion(.failure(.unknown))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Welcome.self, from: data)
                completion(.success(Array(decodedData.todos.prefix(5))))
            } catch {
                print("Decoding error \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }

}
