//
//  DetailsPresenter.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import Foundation
import UIKit

protocol PDetailsPresenter: AnyObject {
    
    //var numberOfCurrency: Int {get}
    
   // func configure(cell: MainScreenTableViewCell, forRow row: Int)
    
    func getVC() -> UIViewController?
    func setData(first: Currency, second: Currency)
    func changeSecondCount(value: String) -> String
    
}

final class DetailsPresenter: PDetailsPresenter {
    
    private var detailsView: DetailsViewController?
    private let model = DetailsData()
    
    func setData(first: Currency, second: Currency) {
        model.setData(first: first, second: second)
        configure()
    }
    
    func setVC(view: DetailsViewController?){
        self.detailsView = view
    }
    
    func configure() {
        detailsView?.setFirst(image: model.getFirstImage(), name: model.getFistName(), cost: model.getFirstCostString())
        detailsView?.setSecond(image: model.getSecondImage(), name: model.getSecondName(), cost: model.getSecondCostString())
        detailsView?.setSecondCount(count: String(model.getSecondCount()))
        detailsView?.setFirstCount(count: String(model.getFirstCount()))
        detailsView?.setName(name: model.getScreenName())
        detailsView?.updateChart()
    }
    
    func getVC() -> UIViewController? {
        print(self.detailsView ?? 0)
        return self.detailsView
    }
    
    func changeSecondCount(value: String) -> String {
        String(model.getNewSecondCout(value: Float(value) ?? 0))
    }
    
//
//    var numberOfCurrency: Int {
//        return model.currencyCount()
//    }
//
//    init() {
//        self.model = model
//    }
//
//    func setVC(view: MainScreenTableViewController){
//        self.mainSreenView = view
//    }
//
//    func getData(id: Int) -> Currency {
//        self.model.getData(id)
//    }
//
//    func configure(cell: MainScreenTableViewCell, forRow row: Int) {
//        let currency = model.getData(row)
//
//        cell.displayName(name: currency.name)
//        let cost = " 1 RUB = \(currency.cost) \(currency.name)"
//        cell.displayCost(cost: cost)
//        cell.displayImage(image: currency.photo)
//
//        //cell.display(title: book.title)
//        //cell.display(author: book.author)
//        //cell.display(releaseDate: book.releaseDate?.relativeDescription() ?? "Unknown")
//    }
    
}
