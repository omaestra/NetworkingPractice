//
//  TVSeriesDetailsMapper.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 03/06/2025.
//

import Foundation

final class TVSeriesDetailsMapper {
    static func map(data: Data, httpResponse: HTTPURLResponse) throws -> Paginated<TVSerieDetails> {
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(Paginated<TVSerieDetails>.self, from: data)
    }
}
