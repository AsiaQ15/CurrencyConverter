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
    func openDetails(index: Int)
    
}

final class MainScreenPresenter: PMainScreenPresenter {
    
    private weak var mainSreenView: MainScreenTableViewController?
    private let model: MainScreenModel
    private var detailsPresnter: PDetailsPresenter
    
    var numberOfCurrency: Int {
        return model.currencyCount()
    }
    
    init(model: MainScreenModel, presenter: PDetailsPresenter) {
        self.model = model
        self.detailsPresnter = presenter
    }
    
    func setVC(view: MainScreenTableViewController?){
        self.mainSreenView = view
    }
    
//    func setNextPresenter(presenter: PDetailsPresenter?){
//        self.detailsPresnter = presenter
//        print(self.detailsPresnter!)
//    }

    func getData(id: Int) -> Currency {
        self.model.getData(id)
    }
    
    func configure(cell: MainScreenTableViewCell, forRow row: Int) {
        let currency = model.getData(row)
        
        cell.displayName(name: currency.name)
        let cost = " 1 \(self.model.getMainCurrency()) = \(currency.cost) \(currency.name)"
        cell.displayCost(cost: cost)
        cell.displayImage(image: currency.photo)
        
        //cell.display(title: book.title)
        //cell.display(author: book.author)
        //cell.display(releaseDate: book.releaseDate?.relativeDescription() ?? "Unknown")
    }
    
    func openDetails(index: Int) {
        if let viewController = detailsPresnter.getVC() {
            let dataForDetail = CurrencyConverterData.data.getDataForDetails(firstCurrency: self.model.getMainCurrency(), secondCurrency: self.getData(id: index).name)
            print(dataForDetail)
            detailsPresnter.setData(first: dataForDetail.0, second: dataForDetail.1, chartData: dataForDetail.2)
            mainSreenView?.navigationController?.pushViewController(viewController, animated: true)
        }
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
