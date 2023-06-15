//
//  MainScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 05.06.2023.
//

import UIKit

protocol IMainScreenPresenter: AnyObject {
    
    var numberOfCurrency: Int {get}
    
    func configure(cell: MainScreenTableViewCell, forRow row: Int)
    func openDetails(index: Int)
    func changeMainCurrency(index: Int)
    
}

final class MainScreenPresenter: IMainScreenPresenter {
    
    private var mainSreenView: MainScreenTableViewController?
    private let model: MainScreenModel
    private let coordinatingController: ICoordinatingController
    
    var numberOfCurrency: Int {
        return model.currencyCount()
    }
    
    init(model: MainScreenModel, coordinatingController: ICoordinatingController) {
        self.model = model
        self.coordinatingController = coordinatingController
    }
    
    func changeMainCurrency(index: Int) {
        model.changeMainCurrency(index: index)
        let mainName = model.getMainCurrency()
        CurrencyConverterData.data.changeMainCurrency(currency: mainName)
        self.model.setData(CurrencyConverterData.data.getDataForMainScreen())
        self.mainSreenView?.reloadData()
    }

    func getData(id: Int) -> Currency {
        self.model.getData(id)
    }
    
    func configure(cell: MainScreenTableViewCell, forRow row: Int) {
        let currency = model.getData(row)
        cell.displayName(name: currency.nameFull)
        let costRound = Double(round(currency.cost * 1000)/1000)
        let cost = " 1 \(currency.name) = \(costRound) \(self.model.getMainCurrency())"
        cell.displayCost(cost: cost)
        cell.displayImage(image: currency.photo)
    }
    
    func openDetails(index: Int) {
        let dataForDetail = CurrencyConverterData.data.getDataForDetails(firstCurrency: self.model.getMainCurrency(), secondCurrency: self.getData(id: index).name)
        self.coordinatingController.push(module: .detailsPresenter, parameters: dataForDetail, animated: true)
    }
    
    func updateData() {
        let pairs = CurrencyConverterData.data.getPairs()
     
        for pair in pairs {
            ConverterAPIDataManager.shared.updateData(currancyPair: pair, type: .actualPrice) { (currencies: [PricePair]?, error: ErrorModel?) in
                if let error = error {
                    print(error.Message!)
                }
                if currencies?.isEmpty ?? true {
                    print("NO data for pair \(pair)")
                } else {
                    if let newCost = currencies?[0].price {
                        CurrencyConverterData.data.updateCost(pair: pair, newCost: newCost )
                    }
                }
                self.model.setData(CurrencyConverterData.data.getDataForMainScreen())
                self.mainSreenView?.reloadData()
                CurrencyConverterData.data.saveData()
            }
        }
        
        for pair in pairs {
            ConverterAPIDataManager.shared.updateData(currancyPair: pair, type: .historical) { (currencies: HistoricalData?, error: ErrorModel?) in
                if let error = error {
                    print(error.Message!)
                }
                if let historicalData = currencies?.historical {
                    CurrencyConverterData.data.updateHistoricalData(pair: pair, data: historicalData)

                }
                CurrencyConverterData.data.saveData()
            }
        }
    }
    
}

extension MainScreenPresenter: INavigationItem {
    
    var vc: UIViewController? {
        self.mainSreenView
    }
    
    func set<Parameters>(parameters: Parameters) {}
    
    func setVC(vc: UIViewController?){
        guard let vcMainScreen = vc as? MainScreenTableViewController else { return }
        self.mainSreenView = vcMainScreen
        self.mainSreenView?.setupHandler(handler: self.updateData)
    }
    
}

