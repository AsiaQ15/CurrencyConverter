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
struct CurrencyInfo {
    let nameShort: String
    let nameFull: String
    let photo: String
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
    private let currenciesPairs = ["RUBEUR", "EURRUB", "RUBUSD", "USDRUB", "USDEUR", "EURUSD"]
    private var availableCurrencies = [ "RUB" , "USD", "EUR"]
    private var mainCurrency = "RUB"
    
    init() {
        //loadData()
        self.loadDataFromStorage()
        //print(currencies["RUB"]?.historicalCost["EUR"])
        //print(currencies["EUR"]?.historicalCost["RUB"])
        getCurrency()

    }
    
    private func loadData(){
        
        var lastCost = ["RUB" : 1, "EUR" : 0.0072132, "USD" : 0.5]
        var historicalCost = ["RUB": ["2023-05-22" : 1, "2023-05-23" : 1],
         "EUR": ["2023-05-22" : 0.0072132, "2023-05-23" : 0.008],
         "USD": ["2023-05-22" : 0.5, "2023-05-23" : 0.03]
        ]
        
        currencies["RUB"] = CurrencyStorage(nameShort: "RUB", nameFull: "Российский рубль", photo: "RUB.jpg", lastCost: lastCost, historicalCost: historicalCost)
        
        lastCost = ["RUB" : 88.86, "EUR" : 1, "USD" : 0.98]
        historicalCost = ["RUB": ["2023-05-22" : 88.887678079, "2023-05-23" : 92.34555676],
                          "EUR": ["2023-05-22" : 1, "2023-05-23" : 1],
                          "USD": ["2023-05-22" : 0.98, "2023-05-23" : 0.83]
                         ]
        currencies["EUR"] = CurrencyStorage(nameShort: "EUR", nameFull: "Евро", photo: "EUR.jpg", lastCost: lastCost, historicalCost: historicalCost)
        
        lastCost = ["RUB" : 91.5, "EUR" : 1.02, "USD" : 1]
        historicalCost = ["RUB": ["2023-05-22" : 91.5909823, "2023-05-23" : 100.5234528],
                          "EUR": ["2023-05-22" : 1.02, "2023-05-23" : 1.23],
                          "USD": ["2023-05-22" : 1, "2023-05-23" : 1]
                         ]
        currencies["USD"] = CurrencyStorage(nameShort: "USD", nameFull: "Доллар США", photo: "USD.jpg", lastCost: lastCost, historicalCost: historicalCost)

    }
    
    func getCurrency() {
        
        let path = Bundle.main.path(forResource: "CurrencyList", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        let obj = listArray[0] as? [String:Any]

        
        var currenciesInfo = [CurrencyStorage]()
        for dataObject in listArray {
            if let currencyInfo = dataObject as? [String:Any] {
                let lastCost = [String : Double]()
                let historicalCost = [String : [String : Double]]()
                currenciesInfo.append(CurrencyStorage(nameShort: currencyInfo["nameShort"] as! String, nameFull: currencyInfo["nameFull"] as! String , photo: currencyInfo["photo"] as! String, lastCost: lastCost, historicalCost: historicalCost))
            }
            
        }

        print(currenciesInfo)
        //        for (key, value) in exchangeData["rates"] as! [String: AnyObject] {
        //            let filteredCountryData = listArray.filtered(using: NSPredicate(format : "code = %@", key))
        //            for filteredCountryDataObject in filteredCountryData {
        //                let object = filteredCountryDataObject as? [String:Any]
        //                let converterItem = ConverterItem(currencyName: object!["name"] as! String, country: object!["country"] as! String, code: key, symbol: object!["symbol"] as! String, amount: value.stringValue)
        //                converterItems.append(converterItem)
        //            }
        //        }
        //        baseConverterItem.convertedList = converterItems
        //        self.presenter?.fetchedConvertedCurrency(self.returnConverterItemsWithBaseConverter(baseConverterItem:
        //                                                                    }
    }
    func getDataForMainScreen() -> ([Currency], String) {
        var mainScreenData = [Currency]()
        //let keys = [ "RUB" , "USD", "EUR"]
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
        
        //let chartData = self.currencies[firstCurrency]?.historicalCost[secondCurrency] ?? [:]
        let chartData = self.currencies[secondCurrency]?.historicalCost[firstCurrency] ?? [:]
//        print(chartData)
//        print(sordDate(data: chartData))
        
        let data = sordDate(data: chartData)
        print(firstData.name)
        print(secondData.name)
        print(data)
        
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
                //self.currencies[firstCurrency]?.historicalCost[secondCurrency]?[price.date] = costRound
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
        
    private func loadDataFromStorage() {
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let infoRequest: NSFetchRequest<InfoEntity> = InfoEntity.fetchRequest()
        do {
            let savedData = try context.fetch(infoRequest)
            for currency in savedData {
                if let shortName = currency.nameShort {
                    let fullName = currency.nameFull ?? shortName
                    let photo = currency.photo ?? ""
                    let lastCost = [String : Double]()
                    let historicalCost = [String : [String : Double]]()
                    self.currencies[shortName] = CurrencyStorage(nameShort: shortName, nameFull: fullName, photo: photo, lastCost: lastCost, historicalCost: historicalCost)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let actualRequest: NSFetchRequest<ActualCostEntity> = ActualCostEntity.fetchRequest()
        do {
            let savedData = try context.fetch(actualRequest)
            for currency in savedData {
                if let currency1 = currency.currency1, let currency2 = currency.currency2 {
                    let cost = currency.cost
                    self.currencies[currency1]?.lastCost[currency2] = cost
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let historicalRequest: NSFetchRequest<HistoricalCostEntity> = HistoricalCostEntity.fetchRequest()
        do {
            let savedData = try context.fetch(historicalRequest)
            for currency in savedData {
                if let currency1 = currency.currency1, let currency2 = currency.currency2 {
                    let cost = currency.cost
                    if let date = currency.date {
                        if self.currencies[currency1]?.historicalCost[currency2] == nil {
                            self.currencies[currency1]?.historicalCost[currency2] = [:]
                        }
                        self.currencies[currency1]?.historicalCost[currency2]?[date] = cost
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveData() {
        for currency in self.currencies.values {
            let info = CurrencyInfo(nameShort: currency.nameShort, nameFull: currency.nameFull, photo: currency.photo)
            let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
            //InfoEntity.createOrUpdate(data: info, with: coreDataStack)
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
    
    func changeMainCurrency(currency: String) {
        if let index = self.availableCurrencies.firstIndex(of: currency) {
            let reserv = self.availableCurrencies.remove(at: index)
            self.availableCurrencies.insert(reserv, at: 0)
            self.mainCurrency = reserv
        }
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
//        let dateFormatter1 = DateFormatter()
//        dateFormatter1.dateFormat = "yy-MM-dd"
//        let dates1 = xValues.compactMap { dateFormatter1.date(from: $0) }
//        print("NEW!")
//        print(dates1)
//
//        print(xValueSort)
//        print(yValueSort)

        return (xValueSort, yValueSort)
    }
    
//    private func deletYear(str: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.dateFormat = "dd-MMMM"
//        let stringDate = dateFormatter.string(from: Date())
//        print(stringDate)
//
//    }
}
            
private struct SortDate {
    var value: Date
    var position: Int
}


//func entityIsEmpty(entity: String) -> Bool
//{
//
//    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var context = NSManagedObjectContext()
//
//    var request = NSFetchRequest(entityName: entity)
//    var error = NSErrorPointer()
//
//    var results:NSArray? = self.context.executeFetchRequest(request, error: error)
//
//    if let res = results
//    {
//        if res.count == 0
//        {
//            return true
//        }
//        else
//        {
//            return false
//        }
//    }
//    else
//    {
//        println("Error: \(error.debugDescription)")
//        return true
//    }
//
//}
