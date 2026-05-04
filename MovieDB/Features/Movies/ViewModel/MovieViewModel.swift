import SwiftUI
import Foundation
import Combine

@MainActor
class MovieViewModel: ObservableObject {
    
    @Published var lastMovies: [Movie]? = nil
    @Published var popularMovies: MovieResponse? = nil
    @Published var ratedMovies: MovieResponse? = nil
    @Published var upcamingMovies: [Movie]? = nil
    @Published var nowPlayingMovies: [Movie]? = nil
    @Published var movies: [Movie]? = nil
    @Published var movie: Movie? = nil
    
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = false
    @Published var nexPageIsLoading: Bool = false
    @Published var errorMessage : String = ""
    @Published var page: Int = 1
    
    private let moviesService: MoviesProtocol
    private var lastAction: (() async -> Void)?
    
    init(moviesService: MoviesProtocol = MoviesService()){
        self.moviesService = moviesService
    }
    
    public func retry() async {
        
    }
    
    public func fetchPopularMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            popularMovies = try await moviesService.fectchPopularMovies()
        } catch  {
            print("Hata: \(error)")
        }
    }
    
    public func fetchLastMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            lastMovies = try await moviesService.fetchLastMovies()
        } catch  {
            print("Hata: \(error)")
        }
    }
    
    public func fetchMovieDetail(id: String?) async {
        guard let id else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            movie = try await moviesService.fectchMovie(id: id)
        } catch {
            print("Hata: \(error)")
        }
    }
    
    public func fetchNextPageIfNeeded(movie: Movie?) async {
        guard movie != nil else {
            await fetchRatedMovies()
            return
        }
        
        guard !nexPageIsLoading,hasNextPage else { return }
        
        let index = ratedMovies?.results.firstIndex(where: {$0.id == movie?.id}) ?? 0
        
        if ratedMovies?.results.count == index + 1{
            await fetchRatedMovies()
        }
    }
    
    private func fetchRatedMovies() async {
        guard !nexPageIsLoading else { return }
        
        nexPageIsLoading = true
        defer { nexPageIsLoading = false }
        
        do {
            let result = try await moviesService.fetchTopRatedMovies(page: page)
            
            if ratedMovies == nil {
                ratedMovies = result
            } else {
                ratedMovies?.results.append(contentsOf: result.results)
            }
            
            hasNextPage = result.results.count == 20
            page += 1
            
        }catch let error as APIError {
            switch error {
            case .unauthorized:
                errorMessage = ""
            case .notFound:
                errorMessage = ""
            case .noInternet:
                errorMessage = ""
            case .serverError(let statusCode):
                errorMessage = "\(statusCode)"
            default:
                errorMessage = ""
            }
            
        } catch {
            print("Hata: \(error)")
        }
    }
}
