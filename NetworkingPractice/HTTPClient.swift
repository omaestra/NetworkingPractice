//
//  HTTPClient.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 02/06/2025.
//

import Foundation
import Combine

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func load(url: URL) async throws -> Result
    func loadPublisher<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
}
