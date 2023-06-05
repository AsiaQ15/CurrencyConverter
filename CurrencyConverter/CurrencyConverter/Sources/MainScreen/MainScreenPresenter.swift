//
//  MainScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 05.06.2023.
//

import UIKit

protocol PMainScreenPresenter: AnyObject {
    
    var numberOfCurrency: Int {get}
    
    func configure(cell: MainScreenTableViewCell, forRow row: Int)
    
}

final class MainScreenPresenter: PMainScreenPresenter {
    
    private weak var mainSreenView: MainScreenTableViewController?
    private let model: CurrencyData
    
    var numberOfCurrency: Int {
        return model.currencyCount()
    }
    
    init(model: CurrencyData) {
        self.model = model
    }
    
    func setVC(view: MainScreenTableViewController){
        self.mainSreenView = view
    }

    func getData(id: Int) -> Currency {
        self.model.getData(id)
    }
    
    func configure(cell: MainScreenTableViewCell, forRow row: Int) {
        let currency = model.getData(row)
        
        cell.displayName(name: currency.name)
        let cost = " 1 RUB = \(currency.cost) \(currency.name)"
        cell.displayCost(cost: cost)
        cell.displayImage(image: currency.photo)
        
        //cell.display(title: book.title)
        //cell.display(author: book.author)
        //cell.display(releaseDate: book.releaseDate?.relativeDescription() ?? "Unknown")
    }
    
}

//extension MVPPresenter: IMVPPresenter
//{
//    func viewDidLoad(ui: IView) {
//        self.ui = ui
//
//        self.ui?.set(text: self.model.firstName)
//        self.ui?.tapButtonHandler = {
//            //
//        }
//    }
//}
//
//
//}
