//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//


import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct DetailView: View {
    @Binding var place: DataModel
    @State var image: String = ""
    @State var name: String = ""
    @State var desc: String = ""
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    var count: Int
    
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    } ()
    
    var body: some View {
        EditView(item: $name)
        HStack {
            List {
                HStack{
                    if let imageUrl = URL(string: image) {
                        ImageView(url: imageUrl)
                    }
                }
                
                TextField("URL:", text: $image)
                HStack {
                    Text("Description:")
                    TextField("Description", text: $desc)
                }
                HStack{
                    Map(coordinateRegion: $region)
                        .frame(height: 300)
                }
                HStack {
                    Text("Longitude:")
                    TextField("Longitude", value: $longitude, formatter: decimalFormatter)
                }
                HStack {
                    Text("Latitude:")
                    TextField("Latitude", value: $latitude, formatter: decimalFormatter)
                }
            }
        }
        .onChange(of: longitude) { newValue in
            updateMapRegion()
        }
        .onChange(of: latitude) { newValue in
            updateMapRegion()
        }
        .navigationTitle(name)
            .navigationBarItems(trailing: EditButton())
            .onAppear {
                image = place.locations[count].image
                name = place.locations[count].name
                desc = place.locations[count].desc
                longitude = place.locations[count].longitude
                latitude = place.locations[count].latitude
                updateMapRegion()
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
    private func updateMapRegion() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
