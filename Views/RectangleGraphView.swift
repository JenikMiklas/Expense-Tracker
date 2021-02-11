//
//  RectangleGraphView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 23.12.2020.
//

import SwiftUI

struct RectangleGraphView: View {
    
    let incomes: CGFloat
    let expences: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 20) {
                Spacer()
                Rectangle()
                    .frame(width: geometry.size.width*0.2, height: geometry.size.height * incomes)
                    .foregroundColor(Color("incomesRect"))
                    .cornerRadius(10)
                Rectangle()
                    .frame(width: geometry.size.width*0.2, height: geometry.size.height * expences)
                    .foregroundColor(Color("expenseRect"))
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

struct RectangleGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleGraphView(incomes: 1, expences: 0.25)
    }
}
