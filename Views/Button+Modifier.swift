//
//  Button+Modifier.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 23.11.2020.
//

import SwiftUI

struct ExpenseButtonMenu: ViewModifier {
 
    var frameSize: CGSize
    
    private let fontSize: CGFloat
    
    init(frameSize: CGSize) {
        self.frameSize = frameSize
        if UIDevice.current.name == "iPhone 8" {
            fontSize = 50
        } else if UIDevice.current.name == "iPod touch (7th generation)" {
            fontSize = 45
        } else if UIDevice.current.name == "iPhone SE (2nd generation)" {
            fontSize = 45
        } else {
            fontSize = 75
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .font(.system(size: fontSize, weight: .black, design: .rounded))
            .frame(width: frameSize.width, height: frameSize.height)
    }
}

struct ExpenseTextMenu: ViewModifier {
 
    let backgroundColor: Color
    
    private let fontSize: CGFloat
    
    init(color: Color) {
        backgroundColor = color
        if UIDevice.current.name == "iPhone 8" {
            fontSize = 50
        } else if UIDevice.current.name == "iPod touch (7th generation)" {
            fontSize = 35
        } else if UIDevice.current.name == "iPhone SE (2nd generation)" {
            fontSize = 45
        } else {
            fontSize = 60
        }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .black, design: .rounded))
            .padding()
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(radius: 20)
            .foregroundColor(.primary)
    }
}

extension View {
    func expenseButtonMenu(size: CGSize = .zero) -> some View {
        self.modifier(ExpenseButtonMenu(frameSize: size))
    }
    func expenseTextMenu(color: Color) -> some View {
        self.modifier(ExpenseTextMenu(color: color))
    }
}
