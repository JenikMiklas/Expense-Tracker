//
//  SettingsCard.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 19.12.2020.
//

import SwiftUI

struct SettingsCard: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    @State private var defaultValueToChange: String = ""
    @State private var locker: Bool = false
    @State private var showSaveButton: Bool = false
    
    let color: Color
    let title: String
    let secondTitle: String
    let viewState: MenuState
    
    var body: some View {
        Group {
            ZStack(alignment: .center) {
                
                if viewState == .first {
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                        Text(title)
                            .padding()
                            .background(color)
                            .cornerRadius(20)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .offset(x: -30)
                            .animation(.easeInOut)
                        if locker {
                            Group {
                                DatePicker("od", selection: $expenseViewModel.dateFrom)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                DatePicker("do", selection: $expenseViewModel.dateTo)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                Button(action: { saveSettings() }, label: {
                                    Text("Filtruj")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                })
                            }
                            .padding()
                            .background(color)
                            .cornerRadius(20)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .accentColor(.primary)
                            .transition(.slide)
                            .animation(.linear)
                        }
                        //Toggle("Automatický", isOn: $toogle)
                        Button(action: { saveSettings() }, label: {
                            Image(systemName: locker ? "lock.open.fill" : "lock.fill")
                        })
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: UIScreen.main.bounds.width * 0.2)
                            .background(color)
                            .cornerRadius(20)
                            .font(.system(size: 25))
                            .offset(x: 70)
                            .animation(.easeInOut)
                    }
                }
                else if viewState == .second {
                    TextField(secondTitle, text: $defaultValueToChange, onCommit:  { saveSettings() })
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: 75)
                        .background(color)
                        .cornerRadius(20)
                    Text(title)
                        .padding()
                        .background(color)
                        .cornerRadius(20)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .offset(x: -UIScreen.main.bounds.width/4, y: -50)
                }
                else if viewState == .third {
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                        Text("Denní limit " + title)
                            .padding()
                            .background(color)
                            .cornerRadius(20)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .offset(x: -40)
                            .animation(.easeInOut)
                        if !expenseViewModel.dymanicDaybalanc {
                            TextField(secondTitle, text: $defaultValueToChange, onCommit:  { saveSettings() })
                                .font(.system(size: 25, weight: .semibold, design: .rounded))
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.85, height: 75)
                                .background(color)
                                .cornerRadius(20)
                                .transition(.slide)
                                .animation(.linear)
                        }
                        Toggle("Dynamický", isOn: $expenseViewModel.dymanicDaybalanc)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 20)
                            .padding()
                            .background(color)
                            .cornerRadius(20)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .offset(x: 25)
                            .animation(.easeInOut)
                    }
                }
                else if viewState == .fourth {
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                        Text("Měna " + title)
                            .padding()
                            .background(color)
                            .cornerRadius(20)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .offset(x: -60)
                            .animation(.easeInOut)
                            .onTapGesture {
                                showSaveButton = true
                            }
                        if showSaveButton {
                            Group {
                                TextField(secondTitle, text: $defaultValueToChange, onCommit:  { saveSettings()
                                })
                                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 75)
                                    .background(color)
                                    .cornerRadius(20)
                                Button(action: {
                                        saveSettings()
                                }) {
                                    Text("Uložit")
                                }
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .padding()
                                .background(color)
                                .cornerRadius(20)
                                .offset(x: 60)
                            }
                            .transition(.slide)
                            .animation(.easeInOut)
                        }
                    }
                }
                else {
                    TextField(secondTitle, text: $defaultValueToChange, onCommit:  { saveSettings() })
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: 75)
                        .background(color)
                        .cornerRadius(20)
                    Text(title)
                        .padding()
                        .background(color)
                        .cornerRadius(20)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .offset(x: -UIScreen.main.bounds.width/4, y: -50)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    private func saveSettings() {
        switch viewState {
        case .first:
            expenseViewModel.readData()
            locker.toggle()
        case .second:
            print("viewState = second")
        case .third:
            expenseViewModel.dayLimitExpense = Double(defaultValueToChange)?.rounded() ?? 0.0
        case .fourth:
            expenseViewModel.fiatMark = defaultValueToChange
            showSaveButton = false
        default:
            print("viewState = default")
        }
    }
}

struct SettingsCard_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCard(color: Color("fourthBGLight"), title: "EUR", secondTitle: "Zadejte znak měny", viewState: .third)
    }
}
