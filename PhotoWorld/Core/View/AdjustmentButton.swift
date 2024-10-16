//
//  AdjustmentButton.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 12/10/24.
//
//
import SwiftUI

struct AdjustmentButton: View {
    @Binding var value: Float
    var range: ClosedRange<Float>
    var iconName: String
    var selected: Bool
    var action: () -> Void

    var body: some View {
        VStack {
            Button(action: action) {

                if selected {

                    ZStack {
                       
                        Circle()
                            .stroke(value >= 0 ? Color.white.opacity(0.3) : Color.white, lineWidth: 3)
                            .frame(width: 35, height: 35)

                        Text("\(Int(value))")
                            .font(.footnote)
                            .foregroundColor(value >= 0 ? .yellow : .white)

                        Circle()
                            .trim(from: value >= 0 ? 0 : -1, to: value >= 0 ? CGFloat(abs(value / (range.upperBound))) : 1 - CGFloat(abs(value / (range.upperBound))))
                            .stroke(value >= 0 ? Color.yellow : Color.black.opacity(0.7), lineWidth: 3)
                            .frame(width: 35, height: 35)
                            .rotationEffect(.degrees(-90))
                    }

                } else {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(selected ? .yellow : .gray)
                        .frame(width: 35, height: 35)
                }
            }
        }
        .frame(width: 40, height: 40)
    }
}
#Preview {
    AdjustmentButton(value: .constant(8),
                     range: -10 ... 10,
                     iconName: "cloud.moon.fill",
                     selected: false,
                     action: {print("button pressed")})
    
}
