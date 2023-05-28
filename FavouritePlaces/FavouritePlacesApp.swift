//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

/// The main entry point of the FavouritePlaces app.
@main
struct FavouritePlacesApp: App {
    /// The data model of the app.
    @State var model: DataModel = DataModel()
    
    /// The main user interface scene of the app.
    var body: some Scene {
        // WindowGroup represents a window in the app's user interface.
        WindowGroup {
            // Display the ContentView as the main view of the app.
            ContentView(model: $model)
        }
    }
}
