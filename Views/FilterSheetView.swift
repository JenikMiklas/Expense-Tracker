//
//  FilterSheetView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 09.12.2020.
//

import SwiftUI

struct FilterSheetView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Binding var showFilterSheet: Bool
    
    var body: some View {
        ZStack {
            Color("firstBGLight")
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text("Upravit Filtr")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                Group {
                    DatePicker("Datum od", selection: $expenseViewModel.dateFrom)
                    DatePicker("Datum do", selection: $expenseViewModel.dateTo)
                }
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .accentColor(.primary)
                Button("Vyfiltruj") {
                    expenseViewModel.readData()
                    showFilterSheet = false
                }
                .font(.system(size: 20, weight: .black, design: .rounded))
            }
            .foregroundColor(.primary)
            .padding(10)
        }
    }
}

struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheetView(showFilterSheet: .constant(false))
    }
}
