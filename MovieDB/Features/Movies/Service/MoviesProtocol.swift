//
//  MoviesProtocol.swift
//  MovieDB
//
//  Created by arneca on 4.05.2026.
//

protocol MoviesProtocol{
    
    func fetchLastMovies() async throws -> [Movie]
    
    func fectchPopularMovies() async throws -> MovieResponse
    
    func fetchTopRatedMovies(page: Int) async throws -> MovieResponse
    
    func fectchUpcomingMovies() async throws -> [Movie]
    
    func fetchNowPlayingMovies() async throws -> [Movie]
    
    func fectchMovie(id: String) async throws -> Movie
    
}
