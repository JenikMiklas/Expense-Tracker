//
//  ExpenseViewModel.swift
//  Expense Tracker
//
//  Created by Jan Miklas on 21.11.2020.
//

import SwiftUI
import CoreData

enum MenuState {
    case menu
    case first
    case second
    case third
    case fourth
    case `default`
}

final class ExpenseViewModel: ObservableObject {
    
    @AppStorage("dayLimitExpenseDefaults") var dayLimitExpenseDefaults: Double = 0
    @AppStorage("fiatMarkDefaults") var fiatMarkDefaults: String = "EUR"
    @AppStorage("dymanicDaybalancDefaults") var dymanicDaybalancDefaults: Bool = false
    
    let persistenceContainer = PersistenceController.shared
    
    // MARK: @Published App data containers
    
    @Published var expenseItems: [Expense] = []
    @Published var selectedExpense: Expense? = nil
    
    // MARK: @Published App states
    @Published var dymanicDaybalanc: Bool = false {
        didSet {
            if dymanicDaybalanc {
                dayLimitExpense = monthBalance / Date.monthDaysRemaining(date: Date())
            }
            dymanicDaybalancDefaults = dymanicDaybalanc
        }
    }
    @Published var menuState: MenuState = .menu
    @Published var showMenu: Bool = false
    @Published var fiatMark: String = "EUR" {
        didSet {
            fiatMarkDefaults = fiatMark
        }
    }
    
    // MARK: @Published dates
    
    @Published var dateFrom: Date = Date.firstOfMonth()
    @Published var dateTo: Date = Date.lastOfMonth()
    
    @Published var dayLimitExpense: Double = 0 {
        didSet {
            if !dymanicDaybalanc {
                dayLimitExpenseDefaults = dayLimitExpense
            }
            dayBalanc = dayLimitExpense
            calculateExpences()
        }
    }
    
    // MARK: @Published vars
    
    @Published var monthIncomes: Double = 0.0
    @Published var monthBalance: Double = 0.0
    @Published var monthExpences: Double = 0.0
    @Published var dayBalanc: Double = 0.0
    
    // MARK: private vars
    //private var privateExpences: Bool = false
    
    init() {
        dymanicDaybalanc = dymanicDaybalancDefaults
        //dayBalanc = dayLimitExpense
        fiatMark = fiatMarkDefaults
        readData()
        if !dymanicDaybalanc {
            dayLimitExpense = dayLimitExpenseDefaults
        } else {
           dayLimitExpense = monthBalance / Date.monthDaysRemaining(date: Date())
        }
        
    }
    
    // MARK: Request form Core Data
    
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        request.predicate = NSPredicate(format: "date >= %@ && date < %@", dateFrom as CVarArg, dateTo as CVarArg)
        do {
            let results = try persistenceContainer.container.viewContext.fetch(request)
            expenseItems = results as! [Expense]
            calculateExpences()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createData(title: String, date: Date, amount: Double, isIncome: Bool) {
        let expense = Expense(context: persistenceContainer.container.viewContext)
        expense.title = title
        expense.date = date
        expense.amount = amount
        expense.isIncome = isIncome
        do {
            if (Date.isSameDay(expense.date!, second: Date()) && !expense.isIncome) { dayBalanc -= expense.amount }
            try persistenceContainer.container.viewContext.save()
            readData()
            calculateExpences()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(expense: Expense) {
        do {
            if (Date.isSameDay(expense.date!, second: Date()) && !expense.isIncome) { dayBalanc += expense.amount }
            persistenceContainer.container.viewContext.delete(expense)
            try persistenceContainer.container.viewContext.save()
            readData()
            calculateExpences()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateData(title: String, date: Date, isIncome: Bool, amount: Double) {
        
        let index = expenseItems.firstIndex(of: selectedExpense!)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")

        
        do {
            let results = try persistenceContainer.container.viewContext.fetch(request) as! [Expense]
            
            let expense = results.first { (expense) -> Bool in
                if expense == selectedExpense { return true }
                else { return false }
            }
            
            expense?.setValue(title, forKey: "title")
            expense?.date = date
            expense?.isIncome = isIncome
            expense?.amount = amount
            
            try persistenceContainer.container.viewContext.save()
            
            self.expenseItems[index!] = expense!
            selectedExpense = nil
        } catch {
            print(error.localizedDescription)
        }
        calculateExpences()
        
    }
    
    // MARK: FUNC Calculations
    
    private func calculateExpences() {
        var localMonthExpences = 0.0
        var localMonthIncomes = 0.0
        var localDayBalanc = dayLimitExpense
        var localChangDayBalanc = false
        
        for expense in expenseItems {
  
            if expense.isIncome {
                localMonthIncomes += expense.amount
            } else  {
                localMonthExpences += expense.amount
            }
            if Date.isSameDay(Date(), second: expense.date!) && !expense.isIncome {
                localDayBalanc -= expense.amount
                localChangDayBalanc = true
            }
        }
        monthIncomes = localMonthIncomes
        monthExpences = localMonthExpences
        monthBalance = monthIncomes - monthExpences
        if localChangDayBalanc { dayBalanc = localDayBalanc }
    }
    
    func calculateDayLimit(day: Int) -> Double {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.month, .year], from: expenseItems.last?.date ?? Date())
        
        let dayString = String(day)+" "
        let monthString = String(dateComponents.month!)
        let yearString = " "+String(dateComponents.year!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MM y"
        let dayLimitDate = dateFormatter.date(from: dayString+monthString+yearString)!
        
        var dayExpenses = 0.0
        
        for expense in expenseItems {
            if Date.isSameDay(expense.date!, second: dayLimitDate) && !expense.isIncome {
                dayExpenses += expense.amount
            }
        }
        return dayLimitExpense - dayExpenses
    }
    
    // MARK: FUNC View States
    
    func showPage(_ page: MenuState) {
        menuState = page
        showMenu = true
    }
    
    func getOffset(geometry: CGSize) -> CGSize {
        switch menuState {
        case .default, .menu:
            return CGSize(width: 0, height: 0)
        case .first:
            return CGSize(width: geometry.width/2+5, height: geometry.height/2+5)
        case .second:
            return CGSize(width: -geometry.width/2-5, height: geometry.height/2+5)
        case .third:
            return CGSize(width: geometry.width/2+5, height: -geometry.height/2-5)
        case .fourth:
            return CGSize(width: -geometry.width/2-5, height: -geometry.height/2-5)
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "ExpenseDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresloved error: \(error)") }
        }
    }
}

// MARK: Date extensions

extension Date {
    static  func firstOfMonth() -> Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        let dayString = "1 "
        let monthString = String(dateComponents.month!)
        let yearString = " "+String(dateComponents.year!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MM y HH:mm:ss"
        return dateFormatter.date(from: dayString+monthString+yearString+" 00:00:00")!
    }
    
    static  func lastOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        var dayString = ""
        let monthString = String(dateComponents.month!)
        let yearString = " "+String(dateComponents.year!)
        
        if let month = dateComponents.month {
            switch month {
            case 1, 3, 5, 7, 8, 10, 12:
                dayString = String(31)+" "
            case 2:
                if dateComponents.isLeapMonth! {
                    dayString = String(29)+" "
                } else {
                    dayString = String(28)+" "
                }
            default:
                dayString = String(30)+" "
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MM y HH:mm:ss"
        return dateFormatter.date(from: dayString+monthString+yearString+" 23:59:59")!
      }
    
    static func isSameDay(_ fist: Date, second: Date) -> Bool {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MM y"
        let fistString = dateFormater.string(from: fist)
        let secondString = dateFormater.string(from: second)
        
        if fistString == secondString { return true }
        else { return false }
    }
    
    static func dayInMonth(date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let dayComponent = calendar.dateComponents([.day], from: date)
        let currentDayComponent = calendar.dateComponents([.day], from: Date())
        return max(dayComponent.day ?? 0, currentDayComponent.day ?? 0)
    }
    
    static func monthDaysRemaining(date: Date) -> Double {
        let currentDay = Date.dayInMonth(date: date)
        let calendar = Calendar(identifier: .gregorian)
        let dayComponent = calendar.dateComponents([.day], from: Date.lastOfMonth())
        return Double(dayComponent.day! - currentDay + 1)
    }
}
