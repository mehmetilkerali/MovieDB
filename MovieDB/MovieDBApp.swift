//
//  MovieDBApp.swift
//  MovieDB
//
//  Created by arneca on 4.05.2026.
//

import SwiftUI
import SwiftData

@main
struct MovieDBApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MoviesView()
        }
        .modelContainer(sharedModelContainer)
    }
}
