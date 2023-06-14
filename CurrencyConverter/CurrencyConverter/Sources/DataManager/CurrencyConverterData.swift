//
//  CurrencyConventerData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

import UIKit
import CoreData

struct CurrencyStorage {
    let nameShort: String
    let nameFull: String
    let photo: String
    //сколько текущая валюта стоит в остальных 
    var lastCost: [String : Double] // [Currency : Cost]
    //сколько в этой валюте стоят остальные ( цена по датам)
    var historicalCost: [String : [String : Double]] // // [Currency : [Date : Cost]]
}

struct CurrencyList {
    let nameShort: String
    let nameFull: String
    let photo: String
}

struct CurrencyInfo {
    let id: Int32
    let name: String
    let isMain: Bool
}

struct CurrencyActual {
    let currency1: String
    let currency2: String
    let cost: Double
}

struct CurrencyHistorical {
    let currency1: String
    let currency2: String
    let cost: Double
    let date: String
    let id: Int32
}

final class CurrencyConverterData {
    
    static let data = CurrencyConverterData()
    private var currencies = [String : CurrencyStorage]()
    private var currenciesPairs = [String]()
    private var availableCurrencies = [String]()
    private var mainCurrency = ""
        
    func loadData() {
        DataManager.dataManager.loadData()
        saveCurrencyInfo()
    }
        
    func setCurrencies(infoCurrency: [CurrencyList], actualCost: [CurrencyActual], historicalCost: [CurrencyHistorical], currencyInfo: [CurrencyInfo]) {
        
        self.currencies = [String : CurrencyStorage]()
        self.availableCurrencies = []
        self.currenciesPairs = []
        var availableCurrenciesR = [String]()
        
        for currency in infoCurrency {
            let lastCost = [String : Double]()
            let historicalCost = [String : [String : Double]]()
            self.currencies[currency.nameShort] = CurrencyStorage(nameShort: currency.nameShort, nameFull: currency.nameFull, photo: currency.photo, lastCost: lastCost, historicalCost: historicalCost)
            availableCurrenciesR.append(currency.nameShort)
        }
        
        for currencyCost in actualCost {
            self.currencies[currencyCost.currency1]?.lastCost[currencyCost.currency2] = currencyCost.cost
        }
                
        for currencyHist in historicalCost {
            let currency1 = currencyHist.currency1
            let currency2 = currencyHist.currency2
            let date = currencyHist.date
            
            if self.currencies[currency1]?.historicalCost[currency2] == nil {
                self.currencies[currency1]?.historicalCost[currency2] = [:]
            }
            self.currencies[currency1]?.historicalCost[currency2]?[date] = currencyHist.cost
        }
        
        for currency in availableCurrenciesR {
            self.currencies[currency]?.lastCost[currency] = 1.0
        }
        
        if currencyInfo.isEmpty {
            self.availableCurrencies = availableCurrenciesR
            self.mainCurrency = availableCurrenciesR[0]
        } else {
            for currency in currencyInfo {
                self.availableCurrencies.append(currency.name)
                if currency.isMain {
                    print(currency.name)
                    self.mainCurrency = currency.name
                }
            }
        }
        
        for currency1 in self.availableCurrencies {
            for currency2 in self.availableCurrencies {
                if currency2 != currency1 {
                    self.currenciesPairs.append("\(currency1)\(currency2)")
                }
            }
        }
        changeFistCurrency(currency: self.mainCurrency)
    }
    
    func getDataForMainScreen() -> ([Currency], String) {
        var mainScreenData = [Currency]()
        for key in self.availableCurrencies {
            if let cur = currencies[key] {
                mainScreenData.append(Currency(name: cur.nameShort, nameFull: cur.nameFull, cost: cur.lastCost[self.mainCurrency] ?? 0, photo: UIImage(imageLiteralResourceName: cur.photo)))
            }
        }
        return (mainScreenData, self.mainCurrency)
    }
    
    func getDataForDetails(firstCurrency: String, secondCurrency: String) -> (Currency, Currency, ([String], [Double])) {
        
        let first = self.currencies[firstCurrency]
        var image = UIImage(systemName: "photo")
        if let imageName = first?.photo {
            image = UIImage(imageLiteralResourceName: imageName)
        }
        let firstData = Currency(name: first?.nameShort ?? "", nameFull: first?.nameFull ?? "" , cost: 1.0, photo: image!)
        
        let second = self.currencies[secondCurrency]
        image = UIImage(systemName: "photo")
        if let imageName = second?.photo {
            image = UIImage(imageLiteralResourceName: imageName)
        }
        let secondData = Currency(name: second?.nameShort ?? "", nameFull: second?.nameFull ?? "" , cost: second?.lastCost[firstCurrency] ?? 1, photo: image!)
        
        let chartData = self.currencies[secondCurrency]?.historicalCost[firstCurrency] ?? [:]
        let data = sordDate(data: chartData)
        
        return (firstData, secondData, data)
    }
    
    func updateCost(pair: String, newCost: Double) {
        let index = pair.index(pair.startIndex, offsetBy: 3)
        let firstCurrency = String(pair.prefix(upTo: index))
        
        let start = pair.index(pair.startIndex, offsetBy: 3)
        let range = start..<pair.endIndex
        let secondCurrency = String(pair[range])
        
        self.currencies[firstCurrency]?.lastCost[secondCurrency] = newCost
        
    }
    
    func updateHistoricalData(pair: String, data: [PriceHistorical]) {
        let index = pair.index(pair.startIndex, offsetBy: 3)
        let firstCurrency = String(pair.prefix(upTo: index))
        
        let start = pair.index(pair.startIndex, offsetBy: 3)
        let range = start..<pair.endIndex
        let secondCurrency = String(pair[range])
        
        self.currencies[firstCurrency]?.historicalCost[secondCurrency] = [:]
        var count = 10
        for price in data {
            if let cost = price.close {
                let costRound = Double (round(1000000 * cost) / 1000000)
                self.currencies[secondCurrency]?.historicalCost[firstCurrency]?[price.date] = costRound
            }
            count -= 1
            if count == 0 {
                break
            }
        }
         
    }
    
    func getPairs() -> [String] {
        self.currenciesPairs
    }
  
    func saveData() {
        let currenciesForStorage = self.currencies.values.map{$0}
        DataManager.dataManager.saveDataInStorage(currencies: currenciesForStorage)
    }
    
    func changeMainCurrency(currency: String) {
        changeFistCurrency(currency: currency)
        self.saveCurrencyInfo()
    }
        
}

private extension CurrencyConverterData {
    private func sordDate(data: [String : Double]) -> ([String], [Double]) {
        let xValues = data.keys.map{String($0)}
        let yValues = data.values.map {Double($0)}
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dates = xValues.compactMap { dateFormatter.date(from: $0) }
        
        var oldData = [SortDate]()
        for i in 0..<dates.count {
            oldData.append(SortDate(value: dates[i], position: i))
        }
        let sortedArray = oldData.sorted { $0.value < $1.value }
        let indexPosition = sortedArray.map { $0.position }
        
        var xValueSort = [String]()
        var yValueSort = [Double]()
        
        for x in indexPosition {
            xValueSort.append(xValues[x])
            yValueSort.append(yValues[x])
        }
        return (xValueSort, yValueSort)
    }
    
    private func saveCurrencyInfo() {
        var currenciesInfo = [CurrencyInfo]()
        var id = 1
        for currency in self.availableCurrencies {
            var isMain = false
            if currency == self.mainCurrency {
                isMain = true
            }
            currenciesInfo.append(CurrencyInfo(id: Int32(id), name: currency, isMain: isMain))
            id += 1
        }
        DataManager.dataManager.saveInfoCurrency(currencies: currenciesInfo)
    }
    
    private func changeFistCurrency(currency: String) {
        if let index = self.availableCurrencies.firstIndex(of: currency) {
            let reserv = self.availableCurrencies.remove(at: index)
            self.availableCurrencies.insert(reserv, at: 0)
            self.mainCurrency = reserv
        }
    }
    
}
            
private struct SortDate {
    var value: Date
    var position: Int
}


