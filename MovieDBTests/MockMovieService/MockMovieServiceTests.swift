@testable import MovieDB
import Testing

@MainActor
struct MockMovieServiceTests {
    
    @Test func mockMovie_failure_notfound_result() async throws {
        let mockApiClient = MockAPINotFoundClient()
        let mockMovieService = MoviesService(apiClient: mockApiClient)
        
        do {
            _ = try await mockMovieService.fetchTopRatedMovies(page: 1)
        } catch let eror as APIError {
            switch eror{
            case .notFound:
                #expect(true)
                return
            default:
                Issue.record("Error type is not correct")
            }
        }
    }
    
    @Test func mockMovie_failure_UnAuthorized_result() async throws {
        let mockApiClient = MockAPIUnAuthorizedClient()
        let mockMovieService = MoviesService(apiClient: mockApiClient)
        
        do {
            _ = try await mockMovieService.fetchTopRatedMovies(page: 1)
        } catch let eror as APIError {
            switch eror{
            case .unauthorized:
                #expect(true)
                return
            default:
                Issue.record("Error type is not correct")
            }
        }
    }

}
