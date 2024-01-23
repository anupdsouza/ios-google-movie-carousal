//
//  ContentView.swift
//  GoogleMovieCarousal
//
//  Created by Anup D'Souza on 23/01/24.
//

import SwiftUI

struct ContentView: View {
    let items = [Color.red, Color.blue, Color.yellow, Color.orange, Color.indigo]
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(item)
                            .frame(width: 200, height: 250)
                    }
                }
                
            }
            .frame(height: 250)
            .scrollIndicators(.hidden)

            Text("Movie Carousal!")

            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
