//
//  ApiClient.swift
//  MovieDB
//
//  Created by arneca on 4.05.2026.
//

import SwiftUI
import Foundation
import Combine
import Network

final class APIClient: APIClientProtocol {
    
    private let baseURL: URL = {
        guard let url = URL(string: Api.BaseUrl) else {
            fatalError("Geçersiz Base URL: \(Api.BaseUrl)")
        }
        return url
    }()
    
    
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        do {
            var components = URLComponents(
                url: baseURL.appendingPathComponent(endpoint.path),
                resolvingAgainstBaseURL: false
            )
            components?.queryItems = endpoint.queryItems
            
            guard let url = components?.url else {
                throw APIError.unknown(URLError(.badURL))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(Api.apiKey)", forHTTPHeaderField: "Authorization")
            endpoint.headers?.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
            request.httpBody = endpoint.body
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(URLError(.badServerResponse))
            }
            
            switch httpResponse.statusCode {
            case 200...299: break
            case 401:       throw APIError.unauthorized
            case 404:       throw APIError.notFound
            case 500...:    throw APIError.serverError(statusCode: httpResponse.statusCode)
            default:        throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
            
        } catch let error as APIError {
            throw error
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet: throw APIError.noInternet
            case .timedOut:               throw APIError.timeout
            default:                      throw APIError.unknown(error)
            }
        } catch {
            throw APIError.unknown(error)
        }
    }
}

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

enum APIError: LocalizedError {
    case noInternet
    case timeout
    case decodingFailed
    case serverError(statusCode: Int)
    case unknown(Error)
    case unauthorized        // ← ekle
    case notFound
    
    // Kullanıcıya gösterilecek mesaj
    var errorDescription: String? {
        switch self {
        case .noInternet:              return "İnternet bağlantısı yok"
        case .timeout:                 return "Bağlantı zaman aşımına uğradı"
        case .decodingFailed:          return "Veri işlenemedi"
        case .serverError(let code):   return "Sunucu hatası: \(code)"
        case .unauthorized:            return "Oturum süresi doldu"
        case .notFound:                return "İçerik bulunamadı"
        case .unknown(let error):      return error.localizedDescription
        }
    }
}

enum Api {
    static let BaseUrl = "https://api.themoviedb.org/3"
    
    static let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MGNjNjczZTc0OTU1NTY3MGY1YjdiN2JjYzU1OTcxMyIsIm5iZiI6MTQ5NTUyNzU3NS44NjIwMDAyLCJzdWIiOiI1OTIzZjA5NGMzYTM2ODA0YTMwMDlmOTciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.4Y3YuRE1s7tZoFgK0Iftx1pM0eNmPGG1rcpIYXrTGWo"
    
    static let language = "tr-TR"
    
    static let popularMovies = "movie/popular"
    static let topRated = "movie/top_rated"
    static let nowPlaying = "movie/now-playing"
    static let upcoming = "movie/upcoming"
    static let search = "search/multi"
    static let popularPerson = "person/popular"
}
