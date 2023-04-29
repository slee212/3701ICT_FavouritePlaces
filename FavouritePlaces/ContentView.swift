//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import CoreData
import SwiftUI

let defaultImage = Image(systemName: "photo").resizable()
var downloadImages :[URL:Image] = [:]

struct ContentView: View {
    @Binding var model: DataModel
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach($model.locations, id:\.self) {
                        $p in
                        NavigationLink(destination: DetailView(place: $p)) {
                            if let imageUrl = URL(string: p.image), let imageData = try?
                                Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
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
                                                    model.locations.append(Place(image: "photo", name: "New Place", desc: "", longitude: "", latitude: ""))
                                                    model.save()
                                                }) {
                                                    Text("+")
                                                },
                                        trailing: EditButton())
            }
        }
        .padding()
    }
}
