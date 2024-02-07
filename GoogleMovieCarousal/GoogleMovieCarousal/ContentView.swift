//
//  ContentView.swift
//  GoogleMovieCarousal
//
//  Created by Anup D'Souza on 23/01/24.
//

import SwiftUI

struct CarouselItem: Identifiable, Equatable {
    private(set) var id: UUID = .init()
    var title: String
    var year: String
    var runtime: String
    var certification: String
    var posterImage: String
    var stillImage: String
}

struct CarousalItemView: View {
    @State var item: CarouselItem
    @Binding var selectedItem: CarouselItem?
    @Namespace private var namespace
    private var expanded: Bool {
        item.id == selectedItem?.id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image(item.posterImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(expanded ?  1.5 : 1, anchor: .topLeading)
                    .frame(width: expanded ? 250 : 150, height: 200)
                    .matchedGeometryEffect(id: "image", in: namespace, anchor: .topLeading, isSource: true)
                    .opacity(expanded ? 0 : 1)
                
                Image(item.stillImage)
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

            Text(item.title)
                .frame(height: 50)
                .lineLimit(1)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
    }
    
    @ViewBuilder func itemDetailsView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            Group {
                Text(item.title)
                    .font(.title2)
                HStack {
                    Text("CBFC: " + item.certification)
                        .padding(.horizontal, 5)
                        .overlay {
                            Rectangle()
                                .stroke(.white, lineWidth: 1)
                        }
                    Text(item.runtime)
                    Text(item.year)
                }
            }
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            
            Button {

            } label: {
                Text("Trailer")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.white)
            }
            .padding(.bottom, 15)
            
        }
        .padding(.horizontal, 10)
    }
}

struct ContentView: View {
    private var items: [CarouselItem] = [
        .init(title: "Oppenheimer", year: "2023", runtime: "3h 1m", certification: "UA", posterImage: "poster1", stillImage: "still1"),
        .init(title: "The Matrix", year: "1999", runtime: "2h 16m", certification: "A", posterImage: "poster2", stillImage: "still2"),
        .init(title: "The Martian", year: "2015", runtime: "2h 24m", certification: "UA", posterImage: "poster3", stillImage: "still3"),
        .init(title: "The Shawshank Redemption", year: "1994", runtime: "2h 22m", certification: "U", posterImage: "poster4", stillImage: "still4"),
        .init(title: "The Godfather", year: "1972", runtime: "2h 55m", certification: "UA", posterImage: "poster5", stillImage: "still5"),
        .init(title: "The Dark Knight", year: "2008", runtime: "2h 32m", certification: "UA", posterImage: "poster6", stillImage: "still6")
    ]
    @State private var selectedItem: CarouselItem?
    
    var body: some View {
        VStack {

            // MARK: Header
            HStack {
                Text("Popular films")
                    .font(.title2.bold())
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                Spacer()
            }

            // MARK: Carousal
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(items, id: \.id) { item in
                            CarousalItemView(item: item, selectedItem: $selectedItem)
                                .frame(width: selectedItem?.id == item.id ? 250 : 150, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .contentShape(Rectangle())
                                .id(item.id)
                                .onTapGesture {
                                    DispatchQueue.main.async {
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            selectedItem = selectedItem?.id == item.id ? nil : item
                                        }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            proxy.scrollTo(selectedItem?.id, anchor: .center)
                                        }
                                    }
                                }
                        }
                    }
                }
                .frame(height: 250)
                .scrollIndicators(.hidden)
            }

            Spacer()
        }
        .padding()
        .background {
            
            // MARK: Background
            ZStack {
                GeometryReader { proxy in

                    Color.black
                    
                    if let image = selectedItem?.posterImage {
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
        .foregroundStyle(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
