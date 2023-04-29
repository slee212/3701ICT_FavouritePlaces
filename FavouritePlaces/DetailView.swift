//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//


import SwiftUI

struct DetailView: View {
    @Binding var place: Place
    @State var image: String = ""
    @State var name: String = ""
    @State var desc: String = ""
    @State var longitude: String = ""
    @State var latitude: String = ""
    var body: some View {
        EditView(item: $name)
        HStack {
            List {
                if let imageUrl = URL(string: image), let imageData = try?
                    Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else if(image == "photo") {
                    Image(systemName: image)
                }
                
                TextField("URL:", text: $image)
                HStack {
                    Text("Description:")
                    TextField("Description", text: $desc)
                }
                HStack {
                    Text("Longitude:")
                    TextField("Longitude", text: $longitude)
                }
                HStack {
                    Text("Latitude:")
                    TextField("Latitude", text: $latitude)
                }
            }
            
        }.navigationTitle(name)
            .navigationBarItems(trailing: EditButton())
            .onAppear {
                image = place.image
                name = place.name
                desc = place.desc
                longitude = place.longitude
                latitude = place.latitude
            }
            .onDisappear() {
                place.image = image
                place.name = name
                place.desc = desc
                place.longitude = longitude
                place.latitude = latitude
                
            }
    }
}
