//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 18.11.2020.
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    
    
    @StateObject var expenseViewModel = ExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseViewModel)
                //.environment(\.managedObjectContext, expenseViewModel.persistenceContainer.container.viewContext)
        }
    }
}
