//
//  ExpenseSheetView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 24.11.2020.
//

import SwiftUI
import CoreData

struct ExpenseSheetView: View {
    
    @Binding var showSheet: Bool
    @Binding var monthExpences: Double
    @Binding var update: Bool
    
    //@Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel

    
    @State private var titleExpense: String = ""
    @State private var amountExpense: String = ""
    @State private var selectedDate: Date = Date()
    @State private var localExpence: Double = 0
    @State private var isIncome: Bool = false
    
    var body: some View {
        ZStack {
            Color("firstBGLight")
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text("Přidat novou položku")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                TextField("Popis", text: $titleExpense)
                    .font(.system(size: 30, weight: .light, design: .rounded))
                TextField("Částka CZK", text: $amountExpense)
                    .font(.system(size: 30, weight: .light, design: .rounded))
                DatePicker("Datum:", selection: $selectedDate)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .accentColor(.primary)
                Toggle("Příjem", isOn: $isIncome)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                Button(update ? "Potvrdit změnu" : "Přidat položku") {
                    if update {
                    if let _ = expenseViewModel.selectedExpense {
                        expenseViewModel.updateData(title: titleExpense, date: selectedDate, isIncome: isIncome, amount: Double(amountExpense) ?? 0)
                        /*expense.title = titleExpense
                        expense.date = selectedDate
                        expense.isIncome = isIncome
                        expense.amount = Double(amountExpense)!*/
                        //monthExpences = localExpence + Double(amountExpense)!
                    }
                    } else {
                        expenseViewModel.createData(title: titleExpense, date: selectedDate, amount: Double(amountExpense) ?? 0, isIncome: isIncome)
                    }
                    self.showSheet = false
                }
                    .font(.system(size: 20, weight: .black, design: .rounded))
            }
            .foregroundColor(.primary)
            .padding(10)
            .onAppear {
                if update {
                    if let expense = expenseViewModel.selectedExpense {
                        titleExpense = expense.title!
                        amountExpense = String(expense.amount)
                        selectedDate = expense.date!
                        isIncome = expense.isIncome
                        localExpence = monthExpences - expense.amount
                        
                        let string = "1 Dec 2020"
                        let formatter4 = DateFormatter()
                        formatter4.dateFormat = "d MMM y"
                        let someDate = formatter4.date(from: string)
                        print(someDate! > selectedDate)
                    }
                }
                //print(Calendar(identifier: .gregorian).c)
            }
            .onDisappear {
                update = false
            }
        }
    }
}

struct ExpenseSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseSheetView(showSheet: .constant(true), monthExpences: .constant(0), update: .constant(false))
    }
}
