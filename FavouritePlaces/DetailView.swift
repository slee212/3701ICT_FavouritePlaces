import SwiftUI
import CoreData
import CoreLocation
import MapKit

import SwiftUI

struct DetailView: View {
    @Binding var place: DataModel
    var count: Int
    
    var body: some View {
        VStack {
            EditView(item: $place.locations[count].name)
            
            HStack {
                List {
                    HStack {
                        if let imageUrl = URL(string: place.locations[count].image) {
                            ImageView(url: imageUrl)
                        }
                    }
                    
                    TextField("URL:", text: $place.locations[count].image)
                    
                    HStack {
                        Text("Description:")
                        TextField("Description", text: $place.locations[count].desc)
                    }
                    
                    NavigationLink(destination: LocationView(place: $place, count: count)) {
                        HStack {
                            Text("Edit Location")
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}
