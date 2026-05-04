import Foundation

struct MovieResponse: Codable {
    let page: Int
    var results: [Movie]
    let dates: Dates?
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results,dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum: String?
    let minimum: String?
}

struct Movie: Codable, Identifiable {
    let id: Int?
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let adult: Bool?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let genreIDs: [Int]
    let media_type: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, video, media_type
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIDs = "genre_ids"
    }
}
