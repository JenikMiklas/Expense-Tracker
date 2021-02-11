//
//  MenuView.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 19.11.2020.
//

import SwiftUI



/*struct ZoomInOutEffect: GeometryEffect {
    
    var scale: CGFloat = 1
    
    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        print(scale)
        return ProjectionTransform(CGAffineTransform(scaleX: cos(scale * 2 * .pi), y: cos(scale * 2 * .pi)))
    }
}*/

struct MenuView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    FirstView()
                        .offset(x: -geometry.size.width/2-5,
                                y: -geometry.size.height/2-5)
                   
                    SecondView()
                        .offset(x: geometry.size.width/2+5,
                                y: -geometry.size.height/2-5)
                    
                    ThirdView()
                        .offset(x: -geometry.size.width/2-5,
                                y: geometry.size.height/2+5)
                      
                    FourthView()
                        .offset(x: geometry.size.width/2+5,
                                y: geometry.size.height/2+5)
                     
                }
                .offset(expenseViewModel.getOffset(geometry: geometry.size))
                .scaleEffect(expenseViewModel.showMenu ? 1 : 0.45)
                .transition(.opacity)
                .animation(Animation.easeInOut(duration: 0.45))
            }
        }
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(ExpenseViewModel())
    }
}
