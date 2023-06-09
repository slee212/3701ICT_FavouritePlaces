//
//  LocationView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

/// Gives more detailed information about a location, including its longitude, latitude, a map of the location and the name of the location.
struct LocationView: View {
    @Binding var place: DataModel
    /// Used as an index to get the location's information from the DataModel.
    var count: Int
    
    @State private var editedName: String = ""
    @State private var editedLongitude: Double = 0.0
    @State private var editedLatitude: Double = 0.0
    @State private var isEditing: Bool = false
    @State private var displayedLocationName: String = ""
    
    /// Formats the longitude and latitude variables.
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(place: Binding<DataModel>, count: Int) {
        _place = place
        self.count = count
        
        let initialLocation = place.wrappedValue.locations[count]
        _editedName = State(initialValue: initialLocation.name)
        _editedLongitude = State(initialValue: initialLocation.longitude)
        _editedLatitude = State(initialValue: initialLocation.latitude)
        _displayedLocationName = State(initialValue: initialLocation.name)
    }
    
    /// Main body of the application.
    var body: some View {
        VStack {
            if isEditing {
                TextField("Location Name", text: $editedName)
            } else {
                Text("Map of \(editedName)")
                    .font(.title)
            }

            Map(coordinateRegion: coordinateRegion)
                .frame(height: 300)
                .onAppear {
                    updateDisplayedLocationName()
                }
            List{
                TextField("Longitude", value: $editedLongitude, formatter: decimalFormatter)
                    .disabled(!isEditing)
                
                TextField("Latitude", value: $editedLatitude, formatter: decimalFormatter)
                    .disabled(!isEditing)
            }
        }
        .navigationBarItems(trailing: editButton)
        .onChange(of: editedName) { _ in
            updateCoordinates()
            updateDisplayedLocationName()
        }
        .onChange(of: editedLongitude) { _ in
            updateDisplayedLocationName()
        }
        .onChange(of: editedLatitude) { _ in
            updateDisplayedLocationName()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        }
    
    private var coordinateRegion: Binding<MKCoordinateRegion> {
        Binding<MKCoordinateRegion>(
            get: {
                let center = CLLocationCoordinate2D(latitude: editedLatitude, longitude: editedLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                return MKCoordinateRegion(center: center, span: span)
            },
            set: { region in
                editedLatitude = region.center.latitude
                editedLongitude = region.center.longitude
            }
        )
    }
    
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
            
            if !isEditing {
                saveChanges()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private var backButton: some View {
        Button(action: {
            saveChanges()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
    
    private func saveChanges() {
        place.locations[count].name = editedName
        place.locations[count].longitude = editedLongitude
        place.locations[count].latitude = editedLatitude
        place.save()
    }
    
    private func updateCoordinates() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(editedName) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                editedLatitude = location.coordinate.latitude
                editedLongitude = location.coordinate.longitude
            }
        }
    }
    
    private func updateDisplayedLocationName() {
        getLocationName(for: editedLatitude, longitude: editedLongitude) { name in
            displayedLocationName = name ?? ""
        }
    }
    
    private func getLocationName(for latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
}
