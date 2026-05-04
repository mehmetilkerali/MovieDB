//
//  ImageView.swift
//  MovieDB
//
//  Created by arneca on 4.05.2026.
//

import SwiftUI

struct ImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)){ image in
            image.image?.resizable()
                .scaledToFill()
        }
    }
}
