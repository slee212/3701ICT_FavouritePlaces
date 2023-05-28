//
//  DataModel.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import Foundation

/// Represents a favorite place.
struct Place: Hashable, Codable {
    var image: String
    var name: String
    var desc: String
    var longitude: Double
    var latitude: Double
}

/// Retrieves the file URL for storing the data model.
func getFile() -> URL? {
    let filename = "myplaces.json"
    let fm = FileManager.default
    
    // Get the document directory URL
    guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    // Append the filename to the document directory URL
    return url.appendingPathComponent(filename)
}

/// The data model for the app.
struct DataModel: Codable {
    ///  Creates a variable which houses all Places saved in the application.
    var locations: [Place]
    
    init() {
        locations = []
        load()
    }
    
    /// Loads the data from the JSON file called "myplaces.json" to the application.
    mutating func load() {
        guard let url = getFile(),
              let data = try? Data(contentsOf: url),
              let datamodel = try? JSONDecoder().decode(DataModel.self, from: data) else {
            // Use testLocations if loading from disk fails
            self.locations = testLocations
            return
        }
        
        // Assign the loaded data model to self.locations
        self.locations = datamodel.locations
    }
    
    /// Saves the data from the application to a JSON file called "myplaces.json"
    func save() {
        guard let url = getFile(),
              let data = try? JSONEncoder().encode(self) else {
            return
        }
        
        // Write the encoded data to the file URL
        try? data.write(to: url)
    }
}

/// If the load function fails to find any data, it will load this pre-made array of locations used for testing.
var testLocations = [
    Place(image: "photo", name: "Brisbane", desc: "Capital of Queensland", longitude: 153.0260, latitude: -27.4705),
    Place(image: "photo", name: "Gold Coast", desc: "Tourist location in Queensland", longitude: 153.4000, latitude: -28.0167),
    Place(image: "photo", name: "Sydney", desc: "Capital of New South Wales", longitude: 151.2093, latitude: -33.8688),
]
