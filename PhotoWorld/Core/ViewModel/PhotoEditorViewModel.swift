//
//  PhotoEditorViewModel.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class PhotoEditorViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var editedImage: UIImage?

    // AAdjustments for the sliders
    @Published var exposure: Float = 0.0
    @Published var contrast: Float = 1.0
    @Published var brightness: Float = 0.0
    @Published var brilliance: Float = 0.0
    @Published var highlights: Float = 0.5
    @Published var shadows: Float = 0.5
   // @Published var blackPoint: Float = 0.5
    @Published var blackPoint: Float = 0.4
    @Published var saturation: Float = 1.0
    @Published var vibrance: Float = 0.0
    @Published var warmth: Float = 6500
    @Published var tint: Float = 0.0
    @Published var filterIntensity: Float = 1.0
    @Published var currentFilter: FilterType = .normal 
    
    @Published var hasChanges: Bool = false
    
    private var context = CIContext()

    init(image: UIImage?) {
        self.originalImage = image
        self.editedImage = image
    }

    private func checkForChanges() {
            // compares current values with initial values
            hasChanges = exposure != 0.0 || contrast != 1.0 || brightness != 0.0 || brilliance != 0.0 || highlights != 0.5 || shadows != 0.5 || blackPoint != 0.5 || saturation != 1.0 || vibrance != 0.0 || warmth != 6500 || tint != 0.0
        }
    
    func applyAdjustments() {
        guard let originalImage = originalImage, let ciImage = CIImage(image: originalImage) else {
            return
        }
        
        var adjustedImage = ciImage
        
        // Exposure filter
        let exposureAdjustFilter = CIFilter.exposureAdjust()
        exposureAdjustFilter.inputImage = adjustedImage
        exposureAdjustFilter.ev = exposure
        if let outputImage = exposureAdjustFilter.outputImage {
            adjustedImage = outputImage
        }
        
        // Brilliance filter
        let BrillianceFilter = CIFilter.colorControls()
        BrillianceFilter.inputImage = adjustedImage
        BrillianceFilter.brightness = brilliance
        BrillianceFilter.contrast = Float(1.0 + brilliance / 2.0) // Adjust contrast
        if let outputImage = BrillianceFilter.outputImage {
            adjustedImage = outputImage
        }
        
        // Highlights y shadows filter
        let highlightsShadowsFilter = CIFilter.highlightShadowAdjust()
        highlightsShadowsFilter.inputImage = adjustedImage
        highlightsShadowsFilter.highlightAmount = highlights
        highlightsShadowsFilter.shadowAmount = shadows
        if let outputImage = highlightsShadowsFilter.outputImage {
            adjustedImage = outputImage
        }
        
        // Contrast, brightness filter
        let contrastBrightnessSatFilter = CIFilter.colorControls()
        contrastBrightnessSatFilter.inputImage = adjustedImage
        contrastBrightnessSatFilter.contrast = contrast
        contrastBrightnessSatFilter.brightness = brightness
        contrastBrightnessSatFilter.saturation = saturation
        if let outputImage = contrastBrightnessSatFilter.outputImage {
            adjustedImage = outputImage
        }
        
        //black point filter
        let blackPointFilter = CIFilter.toneCurve()
        blackPointFilter.inputImage = adjustedImage
        blackPointFilter.point0 = CGPoint(x: 0.0, y: CGFloat(blackPoint * -1))
        blackPointFilter.point1 = CGPoint(x: 0.25, y: 0.25)
        blackPointFilter.point2 = CGPoint(x: 0.5, y: 0.5)
        blackPointFilter.point3 = CGPoint(x: 0.75, y: 0.75)
        blackPointFilter.point4 = CGPoint(x: 1, y: 1)

        if let outputImage = blackPointFilter.outputImage {
            adjustedImage = outputImage
        }
        
        //vibrance
        let vibranceFilter = CIFilter.vibrance()
        vibranceFilter.inputImage = adjustedImage
        vibranceFilter.amount = vibrance
        if let outputImage = vibranceFilter.outputImage {
            adjustedImage = outputImage
        }
        
        //warmth and tint filter
        let temperatureTintFilter = CIFilter.temperatureAndTint()
        temperatureTintFilter.inputImage = adjustedImage
        temperatureTintFilter.neutral = CIVector(x: CGFloat(warmth), y: CGFloat(tint))
        if let outputImage = temperatureTintFilter.outputImage {
            adjustedImage = outputImage
        }
        
        if let cgImage = context.createCGImage(adjustedImage, from: adjustedImage.extent) {
            editedImage = UIImage(cgImage: cgImage)
        }
        
        // Convert CIImage to UIImage before passing it to editedImage
        if let cgImage = context.createCGImage(adjustedImage, from: adjustedImage.extent) {
            self.editedImage = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        }
        
        checkForChanges()

    }
    
    
    func applyVividFilter() {
        guard let originalImage = originalImage, let ciImage = CIImage(image: originalImage) else { return }
        
        var adjustedImage = ciImage
        
        let exposureAdjustFilter = CIFilter.exposureAdjust()
        exposureAdjustFilter.inputImage = adjustedImage
        exposureAdjustFilter.ev = 0.1 * filterIntensity
        if let outputImage = exposureAdjustFilter.outputImage {
            adjustedImage = outputImage
        }
        
        let colorsControlFilter = CIFilter.colorControls()
        colorsControlFilter.inputImage = ciImage
        colorsControlFilter.brightness = 0.1 * filterIntensity
        colorsControlFilter.contrast = 1.0 + (0.2 * filterIntensity)
        colorsControlFilter.saturation = 1.0 + (0.3 * filterIntensity)
        
        let highlightsShadowsFilter = CIFilter.highlightShadowAdjust()
        highlightsShadowsFilter.inputImage = adjustedImage
        highlightsShadowsFilter.highlightAmount = 0.4 * filterIntensity
        highlightsShadowsFilter.shadowAmount = 0.6 * filterIntensity
        if let outputImage = highlightsShadowsFilter.outputImage {
            adjustedImage = outputImage
        }
        
        //black point filter
        let blackPointFilter = CIFilter.toneCurve()
        let intensityAdjustedY0 = -0.3 * filterIntensity
        let y0Value = intensityAdjustedY0
        
        let intensityAdjustedY1 = 0.25 * filterIntensity
        let intensityRemainingY1 = (1 - filterIntensity) * 0.25
        let y1Value = intensityAdjustedY1 + intensityRemainingY1
        
        let intensityAdjustedY2 = 0.5 * filterIntensity
        let intensityRemainingY2 = (1 - filterIntensity) * 0.5
        let y2Value = intensityAdjustedY2 + intensityRemainingY2
        
        let intensityAdjustedY3 = 0.75 * filterIntensity
        let intensityRemainingY3 = (1 - filterIntensity) * 0.75
        let y3Value = intensityAdjustedY3 + intensityRemainingY3
        
        let intensityAdjustedY4 = 1 * filterIntensity
        let intensityRemainingY4 = (1 - filterIntensity) * 1
        let y4Value = intensityAdjustedY4 + intensityRemainingY4
        
        // Asigna los puntos ajustados
        blackPointFilter.point0 = CGPoint(x: 0.0, y: Double(y0Value))
        blackPointFilter.point1 = CGPoint(x: 0.25, y: Double(y1Value))
        blackPointFilter.point2 = CGPoint(x: 0.5, y: Double(y2Value))
        blackPointFilter.point3 = CGPoint(x: 0.75, y: Double(y3Value))
        blackPointFilter.point4 = CGPoint(x: 1, y: Int(y4Value))
        
        if let outputImage = blackPointFilter.outputImage {
            adjustedImage = outputImage
        }
        if let cgImage = context.createCGImage(adjustedImage, from: adjustedImage.extent) {
            self.editedImage = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        }
        
        hasChanges = originalImage != editedImage
    }
    
    func applyVividWarmFilter() {
        guard let originalImage = originalImage, let ciImage = CIImage(image: originalImage) else { return }

        var adjustedImage = ciImage

        // Exposure
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = adjustedImage
        exposureFilter.ev = 0.1 * filterIntensity // Adjust exposure based on intensity
        if let outputImage = exposureFilter.outputImage {
            adjustedImage = outputImage
        }

        // Brightness, contrast and saturation
        let colorControlsFilter = CIFilter.colorControls()
        colorControlsFilter.inputImage = adjustedImage
        colorControlsFilter.brightness = 0.1 * filterIntensity // Scale brightness with intensity
        colorControlsFilter.contrast = 1.0 + (0.2 * filterIntensity) // Scale contrast with intensity
        colorControlsFilter.saturation = 1.0 + (0.3 * filterIntensity) // Scale saturation with intensity
        if let outputImage = colorControlsFilter.outputImage {
            adjustedImage = outputImage
        }

        // Highlights and Shadows
        let highlightsShadowsFilter = CIFilter.highlightShadowAdjust()
        highlightsShadowsFilter.inputImage = adjustedImage
        highlightsShadowsFilter.highlightAmount = 0.4 * filterIntensity // Adjust highlights with intensity
        highlightsShadowsFilter.shadowAmount = 0.6 * filterIntensity // Adjust shadows with intensity
        if let outputImage = highlightsShadowsFilter.outputImage {
            adjustedImage = outputImage
        }

        // Vibrance
        let vibranceFilter = CIFilter.vibrance()
        vibranceFilter.inputImage = adjustedImage
        vibranceFilter.amount = 0.2 * filterIntensity // Scale vibrance with intensity
        if let outputImage = vibranceFilter.outputImage {
            adjustedImage = outputImage
        }

        // Black Point Filter
        let blackPointFilter = CIFilter.toneCurve()
        blackPointFilter.inputImage = adjustedImage
        blackPointFilter.point0 = CGPoint(x: 0.0, y: CGFloat(-0.2 * filterIntensity))
        blackPointFilter.point1 = CGPoint(x: 0.25, y: 0.25)
        blackPointFilter.point2 = CGPoint(x: 0.5, y: 0.5)
        blackPointFilter.point3 = CGPoint(x: 0.75, y: 0.75)
        blackPointFilter.point4 = CGPoint(x: 1, y: 1)
        if let outputImage = blackPointFilter.outputImage {
            adjustedImage = outputImage
        }

        // Temperature and Tint
        let temperatureTintFilter = CIFilter.temperatureAndTint()
        temperatureTintFilter.inputImage = adjustedImage
        let warmthValue = 6500 + (800 * filterIntensity) // Adjust warmth based on intensity
        temperatureTintFilter.neutral = CIVector(x: CGFloat(warmthValue), y: 5 * CGFloat(filterIntensity)) // Adjust tint with intensity
        if let outputImage = temperatureTintFilter.outputImage {
            adjustedImage = outputImage
        }

        if let cgImage = context.createCGImage(adjustedImage, from: adjustedImage.extent) {
            self.editedImage =   UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        }
        
        hasChanges = originalImage != editedImage
    }
    
    func applyCurrentFilter() {
        switch currentFilter {
        case .vivid:
            applyVividFilter()
        case .vividWarm:
            applyVividWarmFilter()
        case .normal:
            resetFilters()
        }
    }
    
    func resetFilters() {
        self.editedImage = self.originalImage
        
        // Adjustments for the sliders
        exposure = 0.0
        contrast = 1.0
        brightness = 0.0
        brilliance = 0.0
        highlights = 0.5
        shadows = 0.5
        blackPoint = 0.5
        saturation = 1.0
        vibrance = 0.0
        warmth = 6500
        tint = 0.0
        hasChanges = false
    }
    
    func updateAdjustmentValue(_ visualValue: Float, for adjustment: AdjustmentType) {
        let mappedValue = mapSliderToActualValue(visualValue, for: adjustment)
        switch adjustment {
        case .exposure:
            exposure = mappedValue
        case .contrast:
            contrast = mappedValue
        case .brightness:
            brightness = mappedValue
        case .highlights:
            highlights = mappedValue
        case .shadows:
            shadows = mappedValue
        case .brilliance:
            brilliance = mappedValue
        case .saturation:
            saturation = mappedValue
        case .vibrance:
            vibrance = mappedValue
        case .warmth:
            warmth = mappedValue
        case .tint:
            tint = mappedValue
        case .blackPoint:
            blackPoint = mappedValue
        case .filterIntensity:
            filterIntensity = mappedValue
        }
        applyAdjustments()
    }

    func mapSliderValue(_ value: Float, for adjustment: AdjustmentType) -> Float {
        switch adjustment {
        case .warmth:
            let minTemp: Float = 2000
            let maxTemp: Float = 9000
            
            //offsetting 0 of the warmth
            if value >= 6500 {
                return (value - 6500) / (maxTemp - 6500) * 100
            } else {
                return (value - 6500) / (6500 - minTemp) * 100
            }
        case .brightness:
            return mapValue(value, fromRange: -0.5...0.5, toRange: -100...100)
        case .contrast:
            if value >= 1 {
                return mapValue(value, fromRange: 1...1.5, toRange: 0...100)
            } else {
                return mapValue(value, fromRange: 0.5...1, toRange: -100...0)
            }
        case .exposure:
            return mapValue(value, fromRange: -2.0...2.0, toRange: -100...100)
        case .saturation:
            return mapValue(value, fromRange: 0.0...2.0, toRange: -100...100)
        case .vibrance:
            return mapValue(value, fromRange: -1.0...1.0, toRange: -100...100)
        case .blackPoint:
            return mapValue(value, fromRange: -0.2...1, toRange: -100...100)

        case .highlights, .shadows:
            return mapValue(value, fromRange: 0.0...1.0, toRange: -100...100)
        case .tint:
            return mapValue(value, fromRange: -100...100, toRange: -100...100)
        case .brilliance:
            return mapValue(value, fromRange: -0.3...0.3, toRange: -100...100)
        case .filterIntensity:
            return mapValue(value, fromRange: 0.95...1.00, toRange: 0...100)
        }
    }

    func mapSliderToActualValue(_ value: Float, for adjustment: AdjustmentType) -> Float {
        switch adjustment {
        case .warmth:
            return mapValue(value, fromRange: -100...100, toRange: 2000...9000)
        case .brightness:
            let scaledValue = mapValue(value, fromRange: -100...100, toRange: -0.5...0.5)
            return scaledValue * abs(scaledValue)
        case .contrast:
            if value >= 1 {
                let scaledValue = mapValue(value, fromRange: 0...100, toRange: 1...1.5)
                return scaledValue * abs(scaledValue)
            } else {
                let scaledValue = mapValue(value, fromRange: -100...0, toRange: 0.5...1)
                return scaledValue * abs(scaledValue)
            }
        case .exposure:
            let scaledValue = mapValue(value, fromRange: -100...100, toRange: -2...2)
            return scaledValue * abs(scaledValue)
        case .saturation:
            return mapValue(value, fromRange: -100...100, toRange: 0.0...2.0)
        case .vibrance:
            let scaledValue = mapValue(value, fromRange: -100...100, toRange: -1...1)
            return scaledValue * abs(scaledValue)
        case .blackPoint:
            
            return mapValue(value, fromRange: -100...100, toRange: -0.2...1)
            
        case .highlights, .shadows:
            return mapValue(value, fromRange: -100...100, toRange: 0.0...1.0)
        case .tint:
            return mapValue(value, fromRange: -100...100, toRange: -100...100)
        case .brilliance:
            let scaledValue = mapValue(value, fromRange: -100...100, toRange: -0.3...0.3)
            return scaledValue * abs(scaledValue)
        case .filterIntensity:
            return mapValue(value, fromRange: 0...100, toRange: 0.0...1.0)
        }
    }

    private func mapValue(_ value: Float, fromRange: ClosedRange<Float>, toRange: ClosedRange<Float>) -> Float {
        let normalized = (value - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (normalized * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }
}

