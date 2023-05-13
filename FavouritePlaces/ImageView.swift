//
//  ImageView.swift
//  FavouritePlaces
//
//  Created by Samuel Lee on 13/5/2023.
//

import SwiftUI

struct ImageView: View {
    @State var uiImage: UIImage? = nil
    let url: URL

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                // Display a placeholder while the image is loading
                Image(systemName: "photo")
            }
        }
        .onAppear {
            fetchImage()
        }
    }

    private func fetchImage() {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            }
        }.resume()
    }
}
