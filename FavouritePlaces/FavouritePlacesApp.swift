//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    @State var model:DataModel = DataModel(locations: testLocations)
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
        }
    }
}
