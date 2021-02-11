//
//  FirstView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 18.11.2020.
//

import SwiftUI
import CoreData

struct FirstView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    //@Environment(\.managedObjectContext) var viewContext
    /*@FetchRequest(entity: Expense.entity(), sortDescriptors:  [NSSortDescriptor(keyPath: \Expense.date, ascending: false)],
                  predicate: NSPredicate(format: "date >= %@ && date < %@", Date.firstOfdecember() as CVarArg, Date.lastOfdecember() as CVarArg)) var expenses: FetchedResults<Expense>*/
    /*@FetchRequest(entity: Expense.entity(), sortDescriptors:  [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]) var expenses: FetchedResults<Expense>*/
    @State private var showSheet: Bool = false
    @State private var update: Bool = false
    @State private var showFilterSheet: Bool = false
    
    private let colorTextBackround = Color("firstBGLight")
    
    var body: some View {
        Color("firstBG")
            .cornerRadius(expenseViewModel.menuState == .first ? 0 : 30)
        
        GeometryReader { geometry in
                Group {
                    VStack(spacing: 0) {
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                                    colorTextBackround
                                        .frame(width: geometry.size.width, height: 90)
                                    Group {
                                        Button(action: { self.showFilterSheet = true }, label: {
                                            Image(systemName: "arrow.up.arrow.down.square")
                                                .foregroundColor(.primary)
                                        })
                                        .font(.system(size: 25, weight: .black, design: .rounded))
                                        .offset(x: -geometry.size.width * 0.4)
                                        .sheet(isPresented: $showFilterSheet) {
                                            FilterSheetView(showFilterSheet: $showFilterSheet)
                                        }
                                        Text("Položky")
                                            .font(.system(size: 30, weight: .black, design: .rounded))
                                        Button(action: { self.showSheet = true }, label: {
                                            Image(systemName: "doc.badge.plus")
                                                .foregroundColor(.primary)
                                        })
                                        .font(.system(size: 25, weight: .black, design: .rounded))
                                        .offset(x: geometry.size.width * 0.4)
                                        .sheet(isPresented: $showSheet) {
                                            ExpenseSheetView(showSheet: $showSheet, monthExpences: $expenseViewModel.monthExpences, update: $update)
                                        }
                                    }
                                    .padding(.bottom, 10)
                                }
                                HStack {
                                    VStack{
                                        Text("Výdaje")
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .font(.subheadline)
                                        Text(String(format: "%.2 f", expenseViewModel.monthExpences))
                                            .font(.title3)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                    .padding([.leading, .trailing], 10)
                                    Spacer()
                                    VStack{
                                        Text("Rozdíl")
                                            .font(.subheadline)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        Text(String(format: "%.2 f", expenseViewModel.monthBalance))
                                            .font(.title3)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                    Spacer()
                                    VStack{
                                        Text("Příjmy")
                                            .font(.subheadline)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        Text(String(format: "%.2 f", expenseViewModel.monthIncomes))
                                            .font(.title3)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                    .padding([.leading, .trailing], 10)
                                    
                                }
                                .background(colorTextBackround)
                                ScrollView(.vertical, showsIndicators: false) {
                                ForEach (expenseViewModel.expenseItems, id:\.objectID) { expense in
                                    ExpenseRowView(expense: expense, fiatMark: expenseViewModel.fiatMark)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .contextMenu {
                                            Button(action: {
                                                //self.expenseViewModel.monthExpences -= expense.amount
                                                expenseViewModel.deleteData(expense: expense)
                                            }, label: {
                                                Text("Remove")
                                                Image(systemName: "trash.fill")
                                            })
                                            Button(action: {
                                                //self.expenseViewModel.monthExpences -= expense.amount
                                                expenseViewModel.selectedExpense = expense
                                                self.update = true
                                                self.showSheet = true
                                            }, label: {
                                                Text("Update")
                                                Image(systemName: "square.and.pencil")
                                            })
                                        }
                                }
                            }
                        }
                }
                .opacity( expenseViewModel.menuState == .first ? 1 : 0)
                .disabled(expenseViewModel.menuState == .menu)
            
            
            VStack(alignment: .trailing) {
                Spacer()
                Button(action: { expenseViewModel.showPage(.first) }, label: {
                    Text(expenseViewModel.expenseItems.first?.title ?? "Výdaj")
                        .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.top, 15)
                Button(action: { expenseViewModel.showPage(.first) }, label: {
                    Text(DateFormatter.localizedString(from: expenseViewModel.expenseItems.first?.date ?? Date(), dateStyle: .short, timeStyle: .none))
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.top, 15)
                Button(action: { expenseViewModel.showPage(.first) }, label: {
                    VStack(alignment: .trailing) {
                        Text(String(expenseViewModel.expenseItems.first?.amount ?? 459))
                        HStack {
                            Text(getIncomeTitle())
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                            Text(expenseViewModel.fiatMark)
                                .font(.system(size: 40, weight: .black, design: .rounded))
                        }
                            
                    }
                    .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.top, 15)
                Button(action: { expenseViewModel.showPage(.first) }, label: {
                    Text("Položky")
                        .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.top, 40)
            }
            .padding(.leading, 90)
            .offset(y: -50)
            //.expenseButtonMenu(size: geometry.size)
            .opacity( expenseViewModel.menuState == .menu ? 1 : 0)
            .disabled(expenseViewModel.menuState == .first)
        }
    }
    func getIncomeTitle() -> String {
        if let expense = expenseViewModel.expenseItems.first {
            if expense.isIncome {
                return "+"
            } else {
                return "-"
            }
        }
        return ""
    }
}

struct FirstView_Previews: PreviewProvider {
    
    static var previews: some View {
        FirstView().environmentObject(ExpenseViewModel())
        FirstView().environmentObject(ExpenseViewModel()).colorScheme(.dark)
    }
}
