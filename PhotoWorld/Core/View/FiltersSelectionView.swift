//
//  FilterSelectionView.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.
//

import SwiftUI

struct FiltersSelectionView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var selectedAdjustment: AdjustmentType = .filterIntensity
    @State private var sliderValue: Float = 100

    var body: some View {
        VStack {
            Text(viewModel.currentFilter.displayName)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 28)
            
            filterSelectionButtons()
          
            
            if viewModel.currentFilter != .normal {
                Slider(value: $sliderValue, in: 30...100)
                    .padding()
                    .onChange(of: sliderValue) { oldValue, newValue in
                        if newValue == 0 {
                            viewModel.resetFilters()
                        } else {
                            let mappedIntensity = viewModel.mapSliderToActualValue(newValue, for: .filterIntensity)
                            viewModel.filterIntensity = mappedIntensity
                            viewModel.applyCurrentFilter()
                        }
                      
                    }
            } else{
                Spacer()
                    .frame(height: 70)
            }
        }
        .frame(height: 180)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
        @ViewBuilder
        private func filterSelectionButtons() -> some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.currentFilter = .normal
                        viewModel.resetFilters()
                        viewModel.hasChanges = true
                    }) {
                        VStack {
                            Image(systemName: "circle")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            
                            Text("Normal")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
    
                    FilterButtonView(filter: .vivid, label: "Vivid", iconName: "sun.max.fill")
                    FilterButtonView(filter: .vividWarm, label: "Vivid Warm", iconName: "sun.max.circle.fill")
                }
                .padding(.horizontal)
            }
        }
    
        @ViewBuilder
        private func FilterButtonView(filter: FilterType, label: String, iconName: String) -> some View {
            FilterButton(
                value: mapSliderValueToDisplay(sliderValue: sliderValue),
                iconName: iconName,
                label: label,
                selected: viewModel.currentFilter == filter,
                action: {
                    viewModel.currentFilter = filter
                    sliderValue = 100
                    viewModel.filterIntensity = 1.0
                    viewModel.applyCurrentFilter()
                }
            )
        }
    
     private func mapSliderValueToDisplay(sliderValue: Float) -> Float {
        let mappedValue = (sliderValue - 30) * 100 / (100 - 30)
        return Float(mappedValue)
    }
}

struct FilterButton: View {
     var value: Float
    
    var iconName: String
    var label: String
    var selected: Bool
    var action: () -> Void
    
   

    var body: some View {
        Button(action: action) {
            VStack {
                
                if selected {
                    
                    ZStack {
                     
                        Circle()
                            .stroke( Color.white, lineWidth: 3)
                            .frame(width: 35, height: 35)

                        
                        Text("\(Int(value))")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                }else {
                    Image(systemName: iconName)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}



#Preview {
    FiltersSelectionView(viewModel: PhotoEditorViewModel(image: UIImage(named: "postcomida")!))
}
