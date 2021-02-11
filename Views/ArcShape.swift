//
//  ArcShape.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 11.12.2020.
//

import SwiftUI

struct ArcShape: Shape {
    
    var startDouble: Double = -90
    var endDouble: Double
    
    func path(in rect: CGRect) -> Path {
        
        let startAngle: Angle = Angle(degrees: Double(startDouble))
        let endAngle: Angle = Angle(degrees: Double(endDouble))
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x + radius * cos(CGFloat(startAngle.radians)),
                            y: center.y + radius * sin(CGFloat(startAngle.radians)))
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}
