@testable import MovieDB

final class MockAPINotFoundClient: APIClientProtocol {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        
        throw APIError.notFound
        
    }
}

final class MockAPIUnAuthorizedClient: APIClientProtocol {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        
        throw APIError.unauthorized
        
    }
}

final class MockAPI500Client: APIClientProtocol {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        
        throw APIError.serverError(statusCode: 500)
        
    }
}

final class MockAPINoInternet: APIClientProtocol {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        
        throw APIError.noInternet
    }
}
