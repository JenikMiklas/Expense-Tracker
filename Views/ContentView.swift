//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 18.11.2020.
//

import SwiftUI

/*struct ZoomInOutEffect: GeometryEffect {
    
    var scale: CGFloat = 0.4
    
    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        print(scale)
        return ProjectionTransform(CGAffineTransform(scaleX: (cos(scale * 2 * .pi)+1.5)/2.5, y: (cos(scale * 2 * .pi)+1.5)/2.5))
    }
}*/

struct ContentView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        ZStack {
            Color("contentViewBG")
                .ignoresSafeArea()
            MenuView()
                .ignoresSafeArea()
            CircleView()
                .frame(width: 50, height: 50)
                .offset(x: UIScreen.main.bounds.width/2*0.75, y: UIScreen.main.bounds.height/2*0.8)
                .opacity( expenseViewModel.menuState == .menu ? 0 : 1)
                .disabled(expenseViewModel.menuState == .menu)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ExpenseViewModel())
    }
}
