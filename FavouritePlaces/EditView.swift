//
//  EditView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 29/4/2023.
//

import SwiftUI

struct EditView: View {
    @Binding var item: String
    @State var displayItem: String = ""
    @Environment(\.editMode) var editMode
    var body: some View {
        VStack {
            if(editMode?.wrappedValue == .active) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    TextField("Input:", text: $displayItem)
                    Button("Cancel") {
                        displayItem = item
                    }
                }
                .onAppear{displayItem = item}
                .onDisappear{item = displayItem}
            }
        }
    }
}
