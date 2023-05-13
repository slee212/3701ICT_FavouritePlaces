//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Binding var model: DataModel
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach(model.locations.enumerated().map { $0 }, id:\.element) {
                        (index, p) in
                        NavigationLink(destination: DetailView(place: $model, count: index)) {
                            if let imageUrl = URL(string: model.locations[index].image) {
                                ImageView(url: imageUrl)
                                    .frame(width: 40, height: 40) // Setting the frame size
                            }
                            
                            Text(p.name)
                        }
                    }
                    .onDelete { idx in
                        model.locations.remove(atOffsets: idx)
                        model.save()
                    }
                    .onMove { idx, i in
                        model.locations.move(fromOffsets: idx, toOffset: i)
                        model.save()
                    }
                }.navigationTitle("My Favourite Places")
                    .navigationBarItems(leading:
                                            Button(
                                                action: {
                                                    model.locations.append(Place(image: "photo", name: "New Place", desc: "", longitude: 0.0, latitude: 0.0))
                                                    model.save()
                                                }) {
                                                    Text("+")
                                                },
                                        trailing: EditButton())
                    .onAppear{model.save()}
            }
        }
        .padding()
    }
}
