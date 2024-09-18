//
//  MovieItemView.swift
//  GoogleMovieCarousal
//
//  Created by Anup D'Souza on 18/09/24.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import SwiftUI

struct MovieStore {
    static func movies() -> [Movie] {
        [
            .init(title: "Oppenheimer", year: "2023", runtime: "3h 1m", certification: "UA", posterImage: "poster1", stillImage: "still1"),
            .init(title: "The Matrix", year: "1999", runtime: "2h 16m", certification: "A", posterImage: "poster2", stillImage: "still2"),
            .init(title: "The Martian", year: "2015", runtime: "2h 24m", certification: "UA", posterImage: "poster3", stillImage: "still3"),
            .init(title: "The Shawshank Redemption", year: "1994", runtime: "2h 22m", certification: "U", posterImage: "poster4", stillImage: "still4"),
            .init(title: "The Godfather", year: "1972", runtime: "2h 55m", certification: "UA", posterImage: "poster5", stillImage: "still5"),
            .init(title: "The Dark Knight", year: "2008", runtime: "2h 32m", certification: "UA", posterImage: "poster6", stillImage: "still6")
        ]
    }
}

struct Movie: Identifiable, Equatable {
    private(set) var id: UUID = .init()
    let title: String
    let year: String
    let runtime: String
    let certification: String
    let posterImage: String
    let stillImage: String
}

struct MovieItemView: View {
    @State var movie: Movie
    @Binding var selectedMovie: Movie?
    @Namespace private var namespace
    private var expanded: Bool { movie.id == selectedMovie?.id }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image(movie.posterImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(expanded ?  1.5 : 1, anchor: .topLeading)
                    .frame(width: expanded ? 250 : 150, height: 200)
                    .matchedGeometryEffect(id: "image", in: namespace, anchor: .topLeading, isSource: true)
                    .opacity(expanded ? 0 : 1)
                
                Image(movie.stillImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: expanded ? 250 : 150, height: 200)
                    .matchedGeometryEffect(id: "image", in: namespace, anchor: .topLeading, isSource: false)
                    .opacity(expanded ? 1 : 0)
                    .overlay(alignment: .leading) {
                        if expanded {
                            itemDetailsView()
                        }
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(movie.title)
                .frame(height: 50)
                .lineLimit(1)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
    }
    
    @ViewBuilder func itemDetailsView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            Group {
                Text(movie.title)
                    .font(.title2)
                HStack {
                    Text("CBFC: " + movie.certification)
                        .padding(.horizontal, 5)
                        .overlay {
                            Rectangle()
                                .stroke(.white, lineWidth: 1)
                        }
                    Text(movie.runtime)
                    Text(movie.year)
                }
            }
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            
            HStack(spacing: 10) {
                Group {
                    Button("Trailer") {}
                    Button("Watch now") {}
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.white)
                }
            }
            .padding(.bottom, 15)
            
        }
        .padding(.horizontal, 10)
    }
}
