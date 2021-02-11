//
//  ExpenseRowView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 23.11.2020.
//

import SwiftUI

struct ExpenseRowView: View {
    
    @ObservedObject var expense: Expense
    let fiatMark: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .trailing, spacing: 3) {
                Text(expense.title ?? "Title")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(DateFormatter.localizedString(from: expense.date ?? Date(), dateStyle: .short, timeStyle: .short))
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .frame(width: UIScreen.main.bounds.width * 0.57, height: 75)
            .padding(5)
            .background(Color("firstBGLight"))
            .cornerRadius(20)
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(String(expense.amount))
                    .font(.title2)
                    .fontWeight(.black)
                HStack {
                    Text(expense.isIncome ? "+" : "-")
                        .font(.title3)
                    Text(fiatMark)
                        .font(.caption)
                        .fontWeight(.bold)
                        .offset(y: 1)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.27, height: 75)
            .padding(5)
            .background(Color("firstBGLight"))
            .cornerRadius(20)
        }
    }
}

struct ExpenseStripView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRowView(expense: Expense(), fiatMark: "CZK")
    }
}
