//
//  PhotoEditorView.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.
//

import SwiftUI

struct PhotoEditorView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var selectedOption: EditingOption? = .adjust
    
    
    var body: some View {
        ZStack {
            Color.black
            VStack{
                Spacer()
                Text(selectedOption == .adjust ? "ADJUST" : "FILTER")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let image = viewModel.editedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 400, height: 400)
                    
                }
                
                if let option = selectedOption {
                    switch option {
                    case .filters:
                        FiltersSelectionView(viewModel: viewModel)
                    case .adjust:
                        AdjustSelectionView(viewModel: viewModel)
                    }
                }
                
                HStack(spacing: 2){
                    //option buttons
                    OptionButtons(icon: "dial.low.fill", label: "Adjust", isSelected: selectedOption == .adjust) {
                        selectedOption = .adjust
                    }
                    
                    OptionButtons(icon: "camera.filters", label: "Filters", isSelected: selectedOption == .filters) {
                        selectedOption = .filters
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
            }
            
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PhotoEditorView(viewModel: PhotoEditorViewModel(image: UIImage(named: "postcomida")!))
}
