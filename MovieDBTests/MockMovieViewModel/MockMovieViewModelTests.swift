//
//  MockMovieViewModelTests.swift
//  MovieDB
//
//  Created by arneca on 5.05.2026.
//
import Testing
@testable import MovieDB

@MainActor
struct MockMovieViewModelTests{
    
    @Test func fethMovies_success_shouldSetMovies() async  {
        
        let mockService = MockMoviesServices()
        let viewModel = MovieViewModel(moviesService: mockService)
        
        await viewModel.fetchNextPageIfNeeded(movie: nil)
        
        #expect(viewModel.ratedMovies?.results.count == 20)
    }
    
    @Test func fetchMovies_success_page_count() async throws {
        let mockService = MockMoviesServices()
        let viewModel = MovieViewModel(moviesService: mockService)
        
        await viewModel.fetchNextPageIfNeeded(movie: nil)
        await viewModel.fetchNextPageIfNeeded(movie: nil)
        await viewModel.fetchNextPageIfNeeded(movie: nil)
        await viewModel.fetchNextPageIfNeeded(movie: nil)
        
        #expect(viewModel.page == 5)
    }
}
