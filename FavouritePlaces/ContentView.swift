//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

var places = [["doc.text.image.fill", "Brisbane"], ["doc.text.image.fill", "Gold Coast"], ["doc.text.image.fill", "Melbourne"]]

struct ContentView: View {
    var body: some View {
        VStack {
            List {
                ForEach(places, id:\.self) {
                    place in
                    HStack {
                        Image(systemName: "doc.text.image.fill")
                        Text(place[1])
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
