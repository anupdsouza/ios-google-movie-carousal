//
//  ContentView.swift
//  GoogleMovieCarousal
//
//  Created by Anup D'Souza on 23/01/24.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import SwiftUI

struct ContentView: View {
    private var movies = MovieStore.movies()
    @State private var selectedMovie: Movie?
    
    var body: some View {
        VStack {
            movieHeaderView()

            movieCarousalView()

            Spacer()
        }
        .padding()
        .background {
            backgroundView()
        }
        .foregroundStyle(.white)
    }
    
    // MARK: Header
    @ViewBuilder private func movieHeaderView() -> some View {
        HStack {
            Text("Popular films")
                .font(.title2.bold())
                .shadow(color: .black, radius: 2, x: 1, y: 1)
            Spacer()
        }
    }

    // MARK: Carousal
    @ViewBuilder private func movieCarousalView() -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(movies, id: \.id) { movie in
                        Movie(movie: movie, proxy: proxy)
                    }
                }
            }
            .frame(height: 250)
            .scrollIndicators(.hidden)
        }
    }

    // MARK: Movie View
    @ViewBuilder private func Movie(movie: Movie, proxy: ScrollViewProxy) -> some View {
        let isSelected = selectedMovie?.id == movie.id
        MovieItemView(movie: movie, selectedMovie: $selectedMovie)
            .frame(width: isSelected ? 250 : 150, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
            .id(movie.id)
            .onTapGesture {
                handleTap(movie: movie, proxy: proxy)
            }
    }

    private func handleTap(movie: Movie, proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.4)) {
                selectedMovie = selectedMovie?.id == movie.id ? nil : movie
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.4)) {
                proxy.scrollTo(selectedMovie?.id, anchor: .center)
            }
        }
    }

    
    // MARK: Background
    @ViewBuilder private func backgroundView() -> some View {
        ZStack {
            Color.black
            
            GeometryReader { proxy in
                
                if let image = selectedMovie?.posterImage {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .overlay {
                            Color.clear
                                .background(.ultraThinMaterial)
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
