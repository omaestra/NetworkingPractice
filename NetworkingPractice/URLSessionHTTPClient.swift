//
//  URLSessionHTTPClient.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 02/06/2025.
//

import Foundation
import Combine

final class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func load(url: URL) async throws -> HTTPClient.Result {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        debugPrint(httpResponse.url?.absoluteString ?? "")
        
        return .success((data, httpResponse))
    }
}

extension URLSessionHTTPClient {
    func loadPublisher<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                debugPrint(result.response)
                
                return result.data
            }
            .decode(type: Paginated<T>.self, decoder: JSONDecoder())
            .tryMap { $0.data }
            .eraseToAnyPublisher()
    }
}
