//
//  Paginated.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 03/06/2025.
//

struct Paginated<T: Decodable>: Decodable {
    let page: Int?
    let totalPages: Int?
    let data: T
}
