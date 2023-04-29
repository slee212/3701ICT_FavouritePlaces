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
    Place(image: "photo", name: "Brisbane"),
    Place(image: "photo", name: "Gold Coast"),
    Place(image: "photo", name: "Sydney"),
]
