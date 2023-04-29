//
//  DataModel.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import Foundation

struct Place: Hashable {
    var image: String
    var name: String
}

struct DataModel {
    var locations:[Place]
}

var testLocations = [
    Place(image: "photo", name: "Brisbane"),
    Place(image: "photo", name: "Gold Coast"),
    Place(image: "photo", name: "Sydney"),
]
