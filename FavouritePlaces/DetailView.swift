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

/// The view for individual locations, loaded when a navigation link is clicked on the ContentView. Provides a more detailed overview of a location including name and description as a few examples.
struct DetailView: View {
    @Binding var place: DataModel
    /// Index used to get the information from the DataModel.
    var count: Int
    
    @State private var sunsetTime: String = ""
    @State private var sunriseTime: String = ""
    @State private var mapSnapshot: UIImage?
    
    /// Main body of the applicaiton.
    var body: some View {
        NavigationView {
            VStack {
                // View for editing the place's name
                EditView(item: $place.locations[count].name)
                
                List {
                    HStack {
                        if let imageUrl = URL(string: place.locations[count].image) {
                            ImageView(url: imageUrl)
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    // Text field for editing the place's image URL
                    TextField("URL:", text: $place.locations[count].image)
                    
                    HStack {
                        Text("Description:")
                        // Text field for editing the place's description
                        TextField("Description", text: $place.locations[count].desc)
                    }
                    
                    // Navigation link to view location details
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
                    
                    // Display sunset and sunrise times if available, or fetch them
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
    
    // Sunset and Sunrise Times
    
    /// Fetches sunset and sunrise times for the location using an API request.
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
    
    /// Generates a map snapshot of the location using MapKit.
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
    
    /// Formats the given time string into a user-friendly format.
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
