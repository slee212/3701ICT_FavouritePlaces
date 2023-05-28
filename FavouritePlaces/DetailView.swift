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

import SwiftUI

struct DetailView: View {
    @Binding var place: DataModel
    var count: Int
    
    @State private var sunsetTime: String = ""
    @State private var sunriseTime: String = ""
    @State private var mapSnapshot: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                EditView(item: $place.locations[count].name)
                
                List {
                    HStack {
                        if let imageUrl = URL(string: place.locations[count].image) {
                            ImageView(url: imageUrl)
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    TextField("URL:", text: $place.locations[count].image)
                    
                    HStack {
                        Text("Description:")
                        TextField("Description", text: $place.locations[count].desc)
                    }
                    
                    NavigationLink(destination: LocationView(place: $place, count: count)) {
                        HStack {
                            if let snapshot = mapSnapshot {
                                Image(uiImage: snapshot)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            } else {
                                Image(systemName: "map")
                                    .foregroundColor(.primary)
                                    .frame(width: 32, height: 32)
                            }
                            
                            Text("View Location Details")
                        }
                    }
                    .foregroundColor(.primary)
                    
                    if !sunsetTime.isEmpty && !sunriseTime.isEmpty {
                        HStack {
                            Image(systemName: "sunset.fill")
                            Text("Sunset Time:")
                            Spacer()
                            Text(sunsetTime)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Image(systemName: "sunrise.fill")
                            Text("Sunrise Time:")
                            Spacer()
                            Text(sunriseTime)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("Fetching sunset and sunrise times...")
                            .foregroundColor(.secondary)
                            .onAppear {
                                fetchSunsetSunriseTimes()
                            }
                    }
                }
            }
            .onAppear {
                generateMapSnapshot()
            }
        }
    }
    
    private func fetchSunsetSunriseTimes() {
        let location = place.locations[count]
        let urlStr = "https://api.sunrise-sunset.org/json?lat=\(location.latitude)&lng=\(location.longitude)&formatted=0"
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                if let sunsetSunriseData = try? JSONDecoder().decode(SunsetSunriseData.self, from: data),
                   let results = sunsetSunriseData.results {
                    DispatchQueue.main.async {
                        sunsetTime = formatTime(results.sunset)
                        sunriseTime = formatTime(results.sunrise)
                    }
                }
            }.resume()
        }
    }
    
    private func generateMapSnapshot() {
        let location = place.locations[count]
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        options.size = CGSize(width: 150, height: 150)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                mapSnapshot = snapshot.image
            }
        }
    }
    
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: timeString) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        
        return ""
    }
}

struct SunsetSunriseData: Codable {
    let results: SunsetSunriseResults?
}

struct SunsetSunriseResults: Codable {
    let sunset: String
    let sunrise: String
}
