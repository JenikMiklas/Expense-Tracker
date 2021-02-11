//
//  CircleView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 20.11.2020.
//

import SwiftUI

struct CircleView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        Button(action: {
            expenseViewModel.menuState = .menu
            expenseViewModel.showMenu = false
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(Color("contentViewBG"))
                Image(systemName: "list.dash")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
            }
        })
        
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView().environmentObject(ExpenseViewModel())
        CircleView().environmentObject(ExpenseViewModel()).colorScheme(.dark)
    }
}
