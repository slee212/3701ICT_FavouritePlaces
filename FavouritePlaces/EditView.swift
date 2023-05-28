//
//  EditView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

/// A view for editing an item.
struct EditView: View {
    @Binding var item: String
    @State var displayItem: String = ""
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack {
            // Show the editing interface when in active edit mode
            if(editMode?.wrappedValue == .active) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    
                    // Text field for editing the item
                    TextField("Input:", text: $displayItem)
                    
                    // Cancel button to revert changes
                    Button("Cancel") {
                        displayItem = item
                    }
                }
                .onAppear {
                    displayItem = item
                }
                .onDisappear {
                    item = displayItem
                }
            }
        }
    }
}
