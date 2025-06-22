//
//  File.swift
//  AppleImagePredict
//
//  Created by NishanthVibishKavi on 3/14/25.
//


import Foundation

extension NumberFormatter {
    
    static var percentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}
