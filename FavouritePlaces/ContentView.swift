//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import CoreData
import SwiftUI

/// The main view of the app, displaying the list of favorite places. With a plus button in the top left to add new locations and a user selected image for each, or a placeholder icon if there is no image.
struct ContentView: View {
    /// The data model of the app, passed as a binding. Used to get the Place information for all the favourite places added through the app.
    @Binding var model: DataModel
    
    /// The body of the application, housing the list of favourite places with each being a navigation link to a detail view about the location.
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach(model.locations.enumerated().map { $0 }, id: \.element) { (index, place) in
                        // Navigation link to the detail view of the place
                        NavigationLink(destination: DetailView(place: $model, count: index)) {
                            // Display the image of the place
                            if let imageUrl = URL(string: model.locations[index].image) {
                                ImageView(url: imageUrl)
                                    .frame(width: 40, height: 40) // Setting the frame size
                            }
                            
                            // Display the name of the place
                            Text(place.name)
                        }
                    }
                    .onDelete { idx in
                        // Remove the place at the specified indices
                        model.locations.remove(atOffsets: idx)
                        model.save()
                    }
                    .onMove { idx, i in
                        // Move the place from one index to another
                        model.locations.move(fromOffsets: idx, toOffset: i)
                        model.save()
                    }
                }
                .navigationTitle("My Favourite Places") // Set the navigation title
                .navigationBarItems(
                    leading: Button(action: {
                        // Add a new place to the data model
                        model.locations.append(Place(image: "photo", name: "New Place", desc: "", longitude: 0.0, latitude: 0.0))
                        model.save()
                    }) {
                        Text("+") // Add button symbol
                    },
                    trailing: EditButton() // Add edit button for reordering and deleting
                )
                .onAppear {
                    model.save() // Save the data model when the view appears
                }
            }
        }
        .padding() // Apply padding to the view
    }
}
