//
//  DataManger.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 14.06.2023.
//

import Foundation
import CoreData

final class DataManager {
    
    static let dataManager = DataManager()
    
    func loadData() {
        let currencies = getCurrency()
//        if infoEntityIsEmpty() {
//            let actualCost = [CurrencyActual]()
//            let historical = [CurrencyHistorical]()
//            CurrencyConverterData.data.setCurrencies(infoCurrency: currencies, actualCost: actualCost, historicalCost: historical)
//            var pairs = CurrencyConverterData.data.getPairs()
//
//            APIloadData(currencyPairs: pairs)
//        } else {
            let actualCost = loadCurrencyActualFromStorage()
            let historical = loadHistoricalFromStorage()
            CurrencyConverterData.data.setCurrencies(infoCurrency: currencies, actualCost: actualCost, historicalCost: historical)
        //}
    }
    

}

private extension DataManager {
    private func infoEntityIsEmpty() -> Bool {
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let infoRequest: NSFetchRequest<InfoEntity> = InfoEntity.fetchRequest()
        do {
            let savedData = try context.fetch(infoRequest)
            guard savedData.isEmpty else { return false}
            return true
        } catch {
            print(error.localizedDescription)
            return true
        }
    }
    
    private func getCurrency() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "CurrencyList", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        var currenciesInfo = [CurrencyInfo]()
        for dataObject in listArray {
            if let currencyInfo = dataObject as? [String:Any] {
                currenciesInfo.append(CurrencyInfo(nameShort: currencyInfo["nameShort"] as! String, nameFull: currencyInfo["nameFull"] as! String, photo: currencyInfo["photo"] as! String))
            }
        }
        return currenciesInfo
    }
    
    private func loadCurrencyActualFromStorage() -> [CurrencyActual] {
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        var currencyActual = [CurrencyActual]()
        
        let actualRequest: NSFetchRequest<ActualCostEntity> = ActualCostEntity.fetchRequest()
        do {
            let savedData = try context.fetch(actualRequest)
            for currency in savedData {
                if let currency1 = currency.currency1, let currency2 = currency.currency2 {
                    let cost = currency.cost
                    currencyActual.append(CurrencyActual(currency1: currency1, currency2: currency2, cost: cost))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return currencyActual
    }
    
    private func loadHistoricalFromStorage() -> [CurrencyHistorical] {
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        var historical = [CurrencyHistorical]()
        let historicalRequest: NSFetchRequest<HistoricalCostEntity> = HistoricalCostEntity.fetchRequest()
        do {
            let savedData = try context.fetch(historicalRequest)
            for currency in savedData {
                if let currency1 = currency.currency1, let currency2 = currency.currency2 {
                    let cost = currency.cost
                    if let date = currency.date {
                        historical.append(CurrencyHistorical(currency1: currency1, currency2: currency2, cost: cost, date: date, id: currency.id))
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return historical
    }
    
    private func APIloadData(currencyPairs: [String]) {
        //let pairs = CurrencyConverterData.data.getPairs()
     
        for pair in currencyPairs {
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
               // self.model.setData(CurrencyConverterData.data.getDataForMainScreen())
               // self.mainSreenView?.reloadData()
                CurrencyConverterData.data.saveData()
            }
        }
        

        for pair in currencyPairs {
            ConverterAPIDataManager.shared.updateData(currancyPair: pair, type: .historical) { (currencies: HistoricalData?, error: ErrorModel?) in
                if let error = error {
                    print(error.Message!)
                   // self.mainSreenView?.showAlertMessage(titleStr: "Error", messageStr: error.Message!)
                }
                if let historicalData = currencies?.historical {
                    CurrencyConverterData.data.updateHistoricalData(pair: pair, data: historicalData)

                }
                CurrencyConverterData.data.saveData()
            }
        }
    }
    
}
