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
        self.mainSreenView?.setupHandler(handler: self.updateData)
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
        
        cell.displayName(name: currency.nameFull)
        let cost = " 1 \(self.model.getMainCurrency()) = \(currency.cost) \(currency.name)"
        cell.displayCost(cost: cost)
        cell.displayImage(image: currency.photo)
    }
    
    func openDetails(index: Int) {
        if let viewController = detailsPresnter.getVC() {
            let dataForDetail = CurrencyConverterData.data.getDataForDetails(firstCurrency: self.model.getMainCurrency(), secondCurrency: self.getData(id: index).name)
            print(dataForDetail)
            detailsPresnter.setData(first: dataForDetail.0, second: dataForDetail.1, chartData: dataForDetail.2)
            mainSreenView?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func updateData() {
        let pairs = CurrencyConverterData.data.getPairs()
     
        for pair in pairs {
            ConverterAPIDataManager.shared.updateData(currancyPair: pair, type: .actualPrice) { (currencies: [PricePair]?, error: ErrorModel?) in
                if let error = error {
                    print(error.Message!)
                    //self.mainSreenView?.showAlertMessage(titleStr: "Error", messageStr: error.Message!)
                }
                if currencies?.isEmpty ?? true {
                    print("NO data for pair \(pair)")
                } else {
                    if let newCost = currencies?[0].price {
                        CurrencyConverterData.data.updateCost(pair: pair, newCost: newCost )
                    }
                }
                self.model.setData(CurrencyConverterData.data.dataForMainScreen(mainCurrency: "RUB"))
                self.mainSreenView?.reloadData()
            }
        }
        

        for pair in pairs {
            ConverterAPIDataManager.shared.updateData(currancyPair: pair, type: .historical) { (currencies: HistoricalData?, error: ErrorModel?) in
                if let error = error {
                    print(error.Message!)
                   // self.mainSreenView?.showAlertMessage(titleStr: "Error", messageStr: error.Message!)
                }
                if let historicalData = currencies?.historical {
                    CurrencyConverterData.data.updateHistoricalData(pair: pair, data: historicalData)

                }
            }
        }

    }
    
}

