//
//  LimitCard.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 18.12.2020.
//

import SwiftUI

struct LimitCard: View {
    
    let day: Int
    let amount: Double
    let limit: Double
    let fiatMark: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ArcShape(endDouble: (((limit - amount) > limit) ? (limit/(limit-amount) * 360) : 360) - 90)
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                    .foregroundColor(Color("circleBig"))
                ArcShape(endDouble: ((limit >= -amount) ? ((limit-amount)/limit * 360) : 360) - 90)
                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                    .foregroundColor(Color("circleSmall"))
                Text(String(day)+".")
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .offset(x: -geometry.size.width/3, y: -geometry.size.height/2+15)
                Text(String(format: "%.0 f", amount))
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(fiatMark)
                    .font(.caption)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .offset(x: geometry.size.width/3, y: geometry.size.height/2-15)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color("thirdBGLight"))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}

struct LimitCard_Previews: PreviewProvider {
    static var previews: some View {
        LimitCard(day: 5, amount: 250, limit: 300, fiatMark: "CZK")
    }
}

