//
//  ContentView.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isNavigating = false 
    @StateObject private var viewModel = PhotoEditorViewModel(image: nil)

    var body: some View {
        NavigationStack {
            VStack {
                // Botón para seleccionar una foto
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Pick a photo")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Capsule().stroke(Color.blue))
                }
                
                .onChange(of: selectedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            viewModel.originalImage = uiImage
                            viewModel.editedImage = uiImage
                            //selectedImage = uiImage
                            isNavigating = true // Activa la navegación
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $isNavigating) {
                if selectedItem != nil {
                    SelectedPhotoView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                        .transition(.move(edge: .top))

                }
            }
            
        }
    }
}


#Preview {
    ContentView()
}
