//
//  AdjustSelectionView.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.

import SwiftUI

struct AdjustSelectionView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var selectedAdjustment: AdjustmentType = .exposure
    @State private var sliderValue: Float = 0.0 // Visual value between -100 and 100

    var body: some View {
        VStack {
            Text(selectedAdjustment.rawValue)
                .font(.headline)
                .padding(.top)
                .foregroundStyle(Color.white)

            // icons to select the adjustment type
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "plusminus.circle",
                                     selected: selectedAdjustment == .exposure) {
                        selectedAdjustment = .exposure
                        sliderValue = viewModel.mapSliderValue(viewModel.exposure, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "sun.max.circle.fill",
                                     selected: selectedAdjustment == .brilliance) {
                        selectedAdjustment = .brilliance
                        sliderValue = viewModel.mapSliderValue(viewModel.brilliance, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "sun.haze",
                                     selected: selectedAdjustment == .highlights) {
                        selectedAdjustment = .highlights
                        sliderValue = viewModel.mapSliderValue(viewModel.highlights, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "cloud.moon.fill",
                                     selected: selectedAdjustment == .shadows) {
                        selectedAdjustment = .shadows
                        sliderValue = viewModel.mapSliderValue(viewModel.shadows, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "circle.lefthalf.fill",
                                     selected: selectedAdjustment == .contrast) {
                        selectedAdjustment = .contrast
                        sliderValue = viewModel.mapSliderValue(viewModel.contrast, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "sun.max",
                                     selected: selectedAdjustment == .brightness) {
                        selectedAdjustment = .brightness
                        sliderValue = viewModel.mapSliderValue(viewModel.brightness, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "drop.fill",
                                     selected: selectedAdjustment == .saturation) {
                        selectedAdjustment = .saturation
                        sliderValue = viewModel.mapSliderValue(viewModel.saturation, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "smallcircle.filled.circle.fill",
                                     selected: selectedAdjustment == .blackPoint) {
                        selectedAdjustment = .blackPoint
                        sliderValue = viewModel.mapSliderValue(viewModel.blackPoint, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "circle.hexagongrid.fill",
                                     selected: selectedAdjustment == .vibrance) {
                        selectedAdjustment = .vibrance
                        sliderValue = viewModel.mapSliderValue(viewModel.vibrance, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "thermometer.sun.fill",
                                     selected: selectedAdjustment == .warmth) {
                        selectedAdjustment = .warmth
                        sliderValue = viewModel.mapSliderValue(viewModel.warmth, for: selectedAdjustment)
                    }

                    AdjustmentButton(value: $sliderValue,
                                     range: -100...100,
                                     iconName: "eyedropper.halffull",
                                     selected: selectedAdjustment == .tint) {
                        selectedAdjustment = .tint
                        sliderValue = viewModel.mapSliderValue(viewModel.tint, for: selectedAdjustment)
                    }
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))

            // Universal slider
            Slider(value: $sliderValue, in: -100...100)
                .padding()
                .onChange(of: sliderValue) { oldValue, newValue in
                    viewModel.updateAdjustmentValue(newValue, for: selectedAdjustment)
                }
        }
        .frame(height: 180)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    AdjustSelectionView(viewModel: PhotoEditorViewModel(image: UIImage(named: "postcomida")!))
}



