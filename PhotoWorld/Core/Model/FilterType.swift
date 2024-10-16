//
//  FilterType.swift
//  PhotoWorld
//
//  Created by Yolima Pereira Ruiz on 15/10/24.
//

enum FilterType {
    case normal
    case vivid
    case vividWarm
    
    var displayName: String {
            switch self {
            case .normal:
                return "Normal"
            case .vivid:
                return "Vivid"
            case .vividWarm:
                return "Vivid Warm"
            }
        }
}
