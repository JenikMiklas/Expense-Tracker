//
//  FourthView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 19.11.2020.
//

import SwiftUI

struct FourthView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    private let colorTextBackround = Color("fourthBGLight")
    
    var body: some View {
        Color("fourthBG")
            .cornerRadius(expenseViewModel.menuState == .fourth ? 0 : 30)
        
        GeometryReader { geometry in
            Group {
                VStack {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        colorTextBackround
                            .frame(width: geometry.size.width, height: 90)
                        Text("Nastavení")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                    }
                    ScrollView(.vertical) {
                        SettingsCard(color: Color("fourthBGLight"), title: expenseViewModel.fiatMark, secondTitle: "Zadejte znak měny", viewState: .fourth)
                            .padding(.bottom, 40)
                        SettingsCard(color: Color("thirdBGLight"), title: String(format: "%.0 f", expenseViewModel.dayLimitExpense), secondTitle: "Zadejte váš denní limit", viewState: .third)
                            .padding(.bottom, 40)
                        SettingsCard(color: Color("firstBGLight"), title: "Výpis za období", secondTitle: "", viewState: .first)
                    }
                }
                //.padding(.bottom, 10)
            }
            .opacity( expenseViewModel.menuState == .fourth ? 1 : 0)
            .disabled(expenseViewModel.menuState == .menu)
            
            VStack(alignment: .leading) {
                Button(action: { expenseViewModel.showPage(.fourth) }, label: {
                    Text("Nastavení")
                        .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.top, 50)
                .padding(.bottom, 40)
                
                Button(action: { expenseViewModel.showPage(.fourth) }, label: {
                    VStack(alignment: .leading) {
                        Image(systemName: "gearshape.2")
                            .font(.system(size: 100, weight: .black, design: .rounded))
                    }
                    .expenseTextMenu(color: colorTextBackround)
                })
                .padding(.bottom, 15)
            }
            .padding(.leading, 10)
            .opacity( expenseViewModel.menuState == .menu ? 1 : 0)
            .disabled(expenseViewModel.menuState == .fourth)
        }
    }
}

struct FourthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView().environmentObject(ExpenseViewModel())
    }
}
