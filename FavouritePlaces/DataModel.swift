//
//  DataModel.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import Foundation

struct Place: Hashable, Codable {
    var image: String
    var name: String
    var desc: String
    var longitude: Double
    var latitude: Double
}

func getFile() -> URL? {
    let filename = "myplaces.json"
    let fm = FileManager.default
    guard let url = fm.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        .first else {
        return nil
    }
    return url.appendingPathComponent(filename)
}

struct DataModel: Codable {
    var locations:[Place]
    init () {
        locations = []
        load()
    }
    
    mutating func load() {
        guard let url = getFile(),
              let data = try? Data(contentsOf: url),
              let datamodel = try? JSONDecoder().decode(DataModel.self, from: data) else {
            self.locations = testLocations
            return
        }
        self.locations = datamodel.locations
    }
    
    func save() {
        guard let url = getFile(),
              let data = try? JSONEncoder().encode(self) else {
            return
        }
        try? data.write(to: url)
    }
}

var testLocations = [
    Place(image: "photo", name: "Brisbane", desc: "Capital of Queensland", longitude: 153.0260, latitude: -27.4705),
    Place(image: "photo", name: "Gold Coast", desc: "Tourist location in Queensland", longitude: 153.4000, latitude: -28.0167),
    Place(image: "photo", name: "Sydney", desc: "Capital of New South Whales", longitude: 151.2093, latitude: -33.8688),
]
