//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//


import SwiftUI

struct DetailView: View {
    @Binding var place: DataModel
    @State var image: String = ""
    @State var name: String = ""
    @State var desc: String = ""
    @State var longitude: String = ""
    @State var latitude: String = ""
    var count: Int
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
                image = place.locations[count].image
                name = place.locations[count].name
                desc = place.locations[count].desc
                longitude = place.locations[count].longitude
                latitude = place.locations[count].latitude
            }
            .onDisappear() {
                place.locations[count].image = image
                place.locations[count].name = name
                place.locations[count].desc = desc
                place.locations[count].longitude = longitude
                place.locations[count].latitude = latitude
                place.save()
                
            }
    }
}
