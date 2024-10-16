//
//  CustomBackButton.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 14/10/24.
//
import SwiftUI

struct CustomBackButton: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            viewModel.resetFilters()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.gray)
                .frame(width: 75,  height: 35)
                .overlay(
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                )
        }
        
    }
}

//#Preview {
//    CustomBackButton()
//}
