import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationStack{
            List(viewModel.ratedMovies?.results ?? []){ movie in
                RowMovieItem(movie: movie).onAppear {
                    Task{
                        await viewModel.fetchNextPageIfNeeded(movie: movie)
                    }
                }
            }
            .navigationTitle("Movies Page: \(viewModel.page)")
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .task {
                await viewModel.fetchNextPageIfNeeded(movie: nil)
            }
        }
    }
}

struct RowMovieItem: View {
    
    let movie : Movie?
    
    var body: some View {
        
        HStack{
            
            ImageView(url: movie?.posterURL?.absoluteString ?? "")
                .frame(width: 55, height: 80)
                .cornerRadius(5)
            
            VStack(alignment: .leading){
                Text(movie?.title ?? "")
                    .bold()
                
                Text("\(movie?.voteAverage ?? 0)")
                    .bold()
                
            }.frame(maxWidth: .infinity,alignment: .leading)
            
            Image(systemName: "arrow.forward")
            
        }.contextMenu {
            Text("")
        } preview: {
            ImageView(url: movie?.posterURL?.absoluteString ?? "")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        }
    }
}

#Preview {
    MoviesView()
}
