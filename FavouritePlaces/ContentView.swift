//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

struct ContentView: View {
    @Binding var model: DataModel
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach(model.locations, id:\.self) {
                        p in
                        HStack {
                            Image(systemName: p.image)
                            Text(p.name)
                        }
                    }
                    .onDelete { idx in
                        model.locations.remove(atOffsets: idx)
                        //model.save()
                    }
                    .onMove { idx, i in
                        model.locations.move(fromOffsets: idx, toOffset: i)
                        //model.save()
                    }
                }.navigationTitle("My Favourite Places")
                    .navigationBarItems(leading:
                                            Button(
                                                action: {
                                                    model.locations.append(Place(image: "photo", name: "New Place"))
                                                }) {
                                                    Text("+")
                                                },
                                        trailing: EditButton())
            }
        }
        .padding()
    }
}
