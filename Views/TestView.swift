//
//  TestView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 07.12.2020.
//

import SwiftUI

struct TestView: View {
    
    private let colorTextBackround = Color("secondBGLight")
    
    var body: some View {
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
                        HStack {
                            ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                                RectangleGraphView(incomes: 1, expences: 0.7)
                                    .frame(width: geometry.size.width*0.5, height: geometry.size.width)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
            //.opacity( expenseViewModel.menuState == .second ? 1 : 0)
            //.disabled(expenseViewModel.menuState == .menu)
            
    }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
