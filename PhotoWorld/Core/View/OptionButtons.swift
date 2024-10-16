//
//  OptionButtons.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 11/10/24.
//
import SwiftUI

struct OptionButtons: View {
    var icon: String
    var label: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack{
                
                    Triangule()
                    .fill(isSelected ? Color.yellow : .black)
                        .frame(width: 15, height: 10)
                
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(isSelected ? Color.white : .gray)
                
                Text(label)
                    .font(.caption)
                    .foregroundStyle(isSelected ? Color.white : .gray)
                
              
            }
        }
        .foregroundColor(.primary)
        .padding()
        
    }
}

struct Triangule: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    OptionButtons(icon: "dial.low.fill",
                  label: "Filter",
                  isSelected: true,
                  action: {print("Botton pressed")})
}
