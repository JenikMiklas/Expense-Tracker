//
//  ThirdView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 19.11.2020.
//

import SwiftUI

struct ThirdView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @State private var expenseString = ""
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let colorTextBackround = Color("thirdBGLight")
    
    var body: some View {
        Color("thirdBG")
            .cornerRadius(expenseViewModel.menuState == .third ? 0 : 30)
            GeometryReader { geometry in
                Group {
                    VStack {
                        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                            colorTextBackround
                                .frame(width: geometry.size.width, height: 90)
                            
                            Text("Denní limity")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .padding(.bottom, 10)
                        }
                        ScrollView {
                            LazyVGrid(columns: layout, spacing: 20) {
                                ForEach(1 ... Date.dayInMonth(date: expenseViewModel.expenseItems.first?.date ?? Date()), id:\.self) { day in
                                    LimitCard(day: day, amount: expenseViewModel.calculateDayLimit(day: day), limit: expenseViewModel.dayLimitExpense, fiatMark: expenseViewModel.fiatMark)
                                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        //.padding(5)
                                        //.background(colorTextBackround)
                                        //.cornerRadius(20)
                                        //.shadow(radius: 20)
                                }
                            }
                        }
                    }
                }
                .opacity( expenseViewModel.menuState == .third ? 1 : 0)
                .disabled(expenseViewModel.menuState == .menu)
                //.blur(radius: expenseViewModel.menuState == .third ? 0 : 20)
                
                
                VStack(alignment: .trailing) {
                    Button(action: { expenseViewModel.showPage(.third) }, label: {
                        Text("Denní limit")
                            .expenseTextMenu(color: colorTextBackround)
                    })
                    .padding(.top, 50)
                    .padding(.bottom, 40)
                
                    Button(action: { expenseViewModel.showPage(.third) }, label: {
                        VStack(alignment: .trailing) {
                            Text(String(format: "%.0 f", expenseViewModel.dayBalanc))
                            Text(expenseViewModel.fiatMark)
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                
                        }
                        .expenseTextMenu(color: colorTextBackround)
                    })
                    .padding(.bottom, 15)
                    Button(action: { expenseViewModel.showPage(.third) }, label: {
                        ZStack(alignment: .center) {
                            ArcShape(endDouble: (((expenseViewModel.dayLimitExpense - expenseViewModel.dayBalanc) > expenseViewModel.dayLimitExpense) ? (expenseViewModel.dayLimitExpense / (expenseViewModel.dayLimitExpense - expenseViewModel.dayBalanc) * 360) : 360) - 90)
                                .frame(width: geometry.size.width*0.5, height: geometry.size.width*0.5)
                                .foregroundColor(Color("circleBig"))
                            ArcShape(endDouble: ((expenseViewModel.dayLimitExpense >= -expenseViewModel.dayBalanc) ? ((expenseViewModel.dayLimitExpense - expenseViewModel.dayBalanc)/expenseViewModel.dayLimitExpense*360) : 360) - 90)
                                .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
                                .foregroundColor(Color("circleSmall"))
                        }
                        .expenseTextMenu(color: colorTextBackround)
                    })
                    Spacer()
                }
                .expenseButtonMenu(size: geometry.size)
                .opacity( expenseViewModel.menuState == .menu ? 1 : 0)
                .disabled(expenseViewModel.menuState == .third)
                 
            }
       
        .onAppear {
            self.expenseString = "\(expenseViewModel.dayLimitExpense)"
        }
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView().environmentObject(ExpenseViewModel())
    }
}


