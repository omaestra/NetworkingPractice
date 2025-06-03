//
//  TVSeriesService.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 15/05/2025.
//

import Foundation
import Combine

protocol TVSeriesService {
    typealias Mapper = (Data, HTTPURLResponse) throws -> Paginated<[TVSerie]>
    typealias DetailsMapper = (Data, HTTPURLResponse) throws -> Paginated<TVSerieDetails>

    func loadAllTVSeriesPublisher() -> AnyPublisher<[TVSerieDetails], Error>
    func loadAllTVSeries() async throws -> [TVSerieDetails]
}

final class APITVSerieService: TVSeriesService {
    let client: HTTPClient
    let url: URL
    let tvSeriesMapper: Mapper
    let tvSeriesDetailsMapper: DetailsMapper
    
    init(
        client: HTTPClient,
        url: URL,
        tvSeriesMapper: @escaping Mapper,
        tvSeriesDetailsMapper: @escaping DetailsMapper
    ) {
        self.client = client
        self.url = url
        self.tvSeriesMapper = tvSeriesMapper
        self.tvSeriesDetailsMapper = tvSeriesDetailsMapper
    }
    
    func loadAllTVSeriesPublisher() -> AnyPublisher<[TVSerieDetails], Error> {
        loadTVSeriesPublisher()
            .flatMap { tvSeries in
                tvSeries
                    .publisher
                    .flatMap { tvSerie in
                        self.loadDetailsPublisher(for: tvSerie)
                    }
                    .collect()
                
        }
        .eraseToAnyPublisher()
    }
    
    /// Loads all TV Series and its details concurrently.
    func loadAllTVSeries() async throws -> [TVSerieDetails] {
        let firstPage = try await loadTVSeriesPage(1)
        var allSeriesDetails: [TVSerieDetails] = try await fetchTVSeriesDetails(for: firstPage.data.map { $0.id })
        
        let totalPages = firstPage.totalPages
        guard let totalPages, totalPages > 1 else { return allSeriesDetails }
        
        let remainingPages = Array(2...totalPages)
        let allRemainingPageData = try await withThrowingTaskGroup(of: Paginated<[TVSerie]>.self) { group in
            for page in remainingPages {
                group.addTask {
                    return try await self.loadTVSeriesPage(page)
                }
            }
            
            var results: [TVSerie] = []
            for try await result in group {
                results.append(contentsOf: result.data)
            }
            return results
        }
        
        let allRemainingTVSeriesIDs = allRemainingPageData.compactMap { $0.id }
        let remainingDetails = try await fetchTVSeriesDetails(for: allRemainingTVSeriesIDs)
        
        allSeriesDetails.append(contentsOf: remainingDetails)
        return allSeriesDetails
    }
}

extension APITVSerieService {
    private func loadTVSeriesPage(_ page: Int) async throws -> Paginated<[TVSerie]> {
        let (data, httpResponse) = try await client.load(url: url.appending(path: "tvseries").appending(queryItems: [URLQueryItem(name: "page", value: String(page))])).get()
        
        return try tvSeriesMapper(data, httpResponse)
    }
    
    private func fetchTVSeriesDetails(for ids: [Int]) async throws -> [TVSerieDetails] {
        var allDetails: [TVSerieDetails] = []
        
        try await withThrowingTaskGroup(of: TVSerieDetails.self) { group in
            for id in ids {
                group.addTask {
                    let url = self.url.appending(path: "tvseries").appending(component: "\(id)")
                    let (data, httpResponse) = try await self.client.load(url: url).get()
                    return try self.tvSeriesDetailsMapper(data, httpResponse).data
                }
            }
            
            for try await detail in group {
                allDetails.append(detail)
            }
        }
        
        return allDetails
    }
    
    private func loadTVSeriesPublisher() -> AnyPublisher<[TVSerie], Error> {
        client.loadPublisher(url: url.appending(path: "tvseries"))
    }
    
    private func loadDetailsPublisher(for tvSerie: TVSerie) -> AnyPublisher<TVSerieDetails, Error> {
        client.loadPublisher(url: url.appending(path: "tvseries").appending(component: "\(tvSerie.id)"))
    }
}
