//
//  TVSerie.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 02/06/2025.
//

struct TVSerie: Decodable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}
