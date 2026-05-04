//
//  MoviesService.swift
//  MovieDB
//
//  Created by arneca on 4.05.2026.
//

import SwiftUI
import Combine

class MoviesService : MoviesProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchLastMovies() async throws -> [Movie] {
        return try await apiClient.request(Endpoint(path: "lastMovies", method: .get))
    }
    
    func fectchPopularMovies() async throws -> MovieResponse {
        return try await apiClient.request(Endpoint(path: Api.popularMovies, method: .get))
    }
    
    func fetchTopRatedMovies(page: Int) async throws -> MovieResponse {
        return try await apiClient.request(Endpoint(path: Api.topRated, method: .get, queryItems: [URLQueryItem(name: "page", value: "\(page)")]))
    }
    
    func fectchUpcomingMovies() async throws -> [Movie] {
        return try await apiClient.request(Endpoint(path: "upCamingMovies", method: .get))
    }
    
    func fetchNowPlayingMovies() async throws -> [Movie] {
        return try await apiClient.request(Endpoint(path: "nowPlayingMovies", method: .get))
    }
    
    func fectchMovie(id: String) async throws -> Movie {
        return try await apiClient.request(Endpoint(path: "lastMovies", method: .get))
    }
}
