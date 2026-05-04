import Testing
@testable import MovieDB

final class MockMoviesServices: MoviesProtocol {
    
    var shouldFail = false
    var mockMovies: [Movie] = Movie.mocks
    var mockTotalPages = 3
    
    var fetchTopRatedCallCount = 0
    
    func fetchLastMovies() async throws -> [MovieDB.Movie] {
        []
    }
    
    func fectchPopularMovies() async throws -> MovieDB.MovieResponse {
        MovieResponse(page: 1, results: [], dates: nil, totalPages: 1, totalResults: 0)
    }
    
    func fetchTopRatedMovies(page: Int) async throws -> MovieDB.MovieResponse {
        fetchTopRatedCallCount += 1
        
        return MovieResponse(
            page: page,
            results: Movie.mocks,
            dates: nil,
            totalPages: mockTotalPages,
            totalResults: mockMovies.count
        )
    }
    
    func fectchUpcomingMovies() async throws -> [MovieDB.Movie] {
        []
    }
    
    func fetchNowPlayingMovies() async throws -> [MovieDB.Movie] {
        []
    }
    
    func fectchMovie(id: String) async throws -> MovieDB.Movie {
        mockMovies[0]
    }
}

extension Movie {
    static let mocks: [Movie] = (1...20).map { i in
        Movie(
            id: i,
            title: "Film \(i)",
            originalTitle: nil,
            originalLanguage: nil,
            overview: "Açıklama \(i)",
            popularity: Double(i),
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            adult: false,
            video: false,
            voteAverage: 7.5,
            voteCount: 100,
            genreIDs: [],
            media_type: nil
        )
    }
}
