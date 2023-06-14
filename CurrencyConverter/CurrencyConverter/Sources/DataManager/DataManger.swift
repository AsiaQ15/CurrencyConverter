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
            let actualCost = loadCurrencyActualFromStorage()
            let historical = loadHistoricalFromStorage()
            let currencyInfo = loadCurrencyInfo()
            CurrencyConverterData.data.setCurrencies(infoCurrency: currencies, actualCost: actualCost, historicalCost: historical, currencyInfo: currencyInfo)
    }
    
    func saveDataInStorage(currencies: [CurrencyStorage]) {
        for currency in currencies {
            let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
            for actualCost in currency.lastCost {
                let cost = CurrencyActual(currency1: currency.nameShort, currency2: actualCost.key, cost: actualCost.value)
                ActualCostEntity.createOrUpdate(data: cost, with: coreDataStack)
            }
            
            for currency2 in currency.historicalCost.keys {
                if let dataForCurrency = currency.historicalCost[currency2] {
                    var countDate = 1
                    for data in dataForCurrency {
                        let hCost = CurrencyHistorical(currency1: currency.nameShort, currency2: currency2, cost: data.value, date: data.key, id: Int32(countDate))
                        HistoricalCostEntity.createOrUpdate(data: hCost, with: coreDataStack)
                        countDate += 1
                    }
                }
            }
        }
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func saveInfoCurrency(currencies: [CurrencyInfo]) {
        for currency in currencies {
            let info = CurrencyInfo(id: currency.id, name: currency.name, isMain: currency.isMain)
            let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
            InfoEntity.createOrUpdate(data: info, with: coreDataStack)
        }
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
}

private extension DataManager {
    private func getCurrency() -> [CurrencyList] {
        let path = Bundle.main.path(forResource: "CurrencyList", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        var currenciesInfo = [CurrencyList]()
        for dataObject in listArray {
            if let currencyInfo = dataObject as? [String:Any] {
                currenciesInfo.append(CurrencyList(nameShort: currencyInfo["nameShort"] as! String, nameFull: currencyInfo["nameFull"] as! String, photo: currencyInfo["photo"] as! String))
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
    
    private func loadCurrencyInfo() -> [CurrencyInfo] {
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        var currencyInfo = [CurrencyInfo]()
        
        let actualRequest: NSFetchRequest<InfoEntity> = InfoEntity.fetchRequest()
        do {
            let savedData = try context.fetch(actualRequest)
            for currency in savedData {
                if let name = currency.name {
                    let isMain = Bool(currency.isMain ?? "false") ?? false
                    currencyInfo.append(CurrencyInfo(id: currency.id, name: name, isMain: isMain))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return currencyInfo
    }
    
}

