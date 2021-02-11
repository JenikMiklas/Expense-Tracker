//
//  SecondView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 19.11.2020.
//


import SwiftUI

struct SecondView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
   
    private let colorTextBackround = Color("secondBGLight")
    
    var body: some View {
            Color("secondBG")
                .cornerRadius(expenseViewModel.menuState == .second ? 0 : 30)
            GeometryReader { geometry in
                Group {
                    VStack {
                        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                            colorTextBackround
                                .frame(width: geometry.size.width, height: 90)
                            Text("Zůstatek")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            RectangleGraphView(incomes: 5000, expences: 2889)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                        }
                    }
                }
                .opacity( expenseViewModel.menuState == .second ? 1 : 0)
                .disabled(expenseViewModel.menuState == .menu)
                
                VStack(alignment: .leading) {
                    Spacer()
                    Button(action: { expenseViewModel.showPage(.second) }, label: {
                        RectangleGraphView(incomes: getGraphHeight(expenseViewModel.monthIncomes), expences: getGraphHeight(expenseViewModel.monthExpences))
                            .expenseTextMenu(color: colorTextBackround)
                            .frame(width: getFrameSize(frame: geometry.size).width, height: getFrameSize(frame: geometry.size).width)
                    })
                    Button(action: { expenseViewModel.showPage(.second) }, label: {
                        Text("Měsíční balanc")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .expenseTextMenu(color: colorTextBackround)
                    })
                    .padding(.top, 15)
                    Button(action: { expenseViewModel.showPage(.second) }, label: {
                        VStack(alignment: .trailing) {
                            Text(String(format: "%.0 f", expenseViewModel.monthBalance))
                            Text(expenseViewModel.fiatMark)
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                
                        }
                            .expenseTextMenu(color: colorTextBackround)
                    })
                    .padding(.top, 15)
                    Button(action: { expenseViewModel.showPage(.second) }, label: {
                        Text("Přehled")
                            .expenseTextMenu(color: colorTextBackround)
                    })
                    .padding(.top, 40)
                }
                .padding(.leading, 15)
                .offset(y: -50)
                //.expenseButtonMenu(size: geometry.size)
                .opacity( expenseViewModel.menuState == .menu ? 1 : 0)
                .disabled(expenseViewModel.menuState == .second)
                
        }
    }
    func getGraphHeight(_ input: Double) -> CGFloat {
        if expenseViewModel.monthIncomes <= expenseViewModel.monthExpences {
                return CGFloat(input/expenseViewModel.monthExpences)
        } else {
            return CGFloat(input/expenseViewModel.monthIncomes)
            
        }
    }
    func getFrameSize(frame: CGSize) -> CGSize {
        if UIDevice.current.name == "iPhone 8" {
            return CGSize(width: frame.width * 0.4, height: frame.height * 0.4)
        } else if UIDevice.current.name == "iPod touch (7th generation)" {
            return CGSize(width: frame.width * 0.3, height: frame.height * 0.3)
        } else if UIDevice.current.name == "iPhone SE (2nd generation)" {
            return CGSize(width: frame.width * 0.4, height: frame.height * 0.3)
        } else {
            return CGSize(width: frame.width * 0.5, height: frame.height * 0.5)
        }
    }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView().environmentObject(ExpenseViewModel())
    }
}
