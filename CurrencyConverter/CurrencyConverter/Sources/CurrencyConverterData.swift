//
//  CurrencyConventerData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

import UIKit

struct CurrencyStorage {
    let nameShort: String
    let nameFull: String
    let photo: String
    //сколько текущая валюта стоит в остальных 
    let lastCost: [String : Double] // [Currency : Cost]
    //сколько в этой валюте стоят остальные ( цена по датам)
    let historicalCost: [String : [String : Double]] // // [Currency : [Date : Cost]]
    
}

final class CurrencyConverterData {
    
    static let data = CurrencyConverterData()
    private var currencies = [String : CurrencyStorage]()
    
    init() {
        loadData()
    }
    
    private func loadData(){
        
        var lastCost = ["RUB" : 1, "EUR" : 0.0072132, "USD" : 0.5]
        var historicalCost = ["RUB": ["2023-05-22" : 1, "2023-05-23" : 1],
         "EUR": ["2023-05-22" : 0.0072132, "2023-05-23" : 0.008],
         "USD": ["2023-05-22" : 0.5, "2023-05-23" : 0.03]
        ]
        
        currencies["RUB"] = CurrencyStorage(nameShort: "RUB", nameFull: "Российский рубль", photo: "RUB.jpg", lastCost: lastCost, historicalCost: historicalCost)
        
        lastCost = ["RUB" : 88.86, "EUR" : 1, "USD" : 0.98]
        historicalCost = ["RUB": ["2023-05-22" : 88.88, "2023-05-23" : 92.3456],
                          "EUR": ["2023-05-22" : 1, "2023-05-23" : 1],
                          "USD": ["2023-05-22" : 0.98, "2023-05-23" : 0.83]
                         ]
        currencies["EUR"] = CurrencyStorage(nameShort: "EUR", nameFull: "Евро", photo: "EUR.jpg", lastCost: lastCost, historicalCost: historicalCost)
        
        lastCost = ["RUB" : 91.5, "EUR" : 1.02, "USD" : 1]
        historicalCost = ["RUB": ["2023-05-22" : 91.5, "2023-05-23" : 100],
                          "EUR": ["2023-05-22" : 1.02, "2023-05-23" : 1.23],
                          "USD": ["2023-05-22" : 1, "2023-05-23" : 1]
                         ]
        currencies["USD"] = CurrencyStorage(nameShort: "USD", nameFull: "Доллар США", photo: "USD.jpg", lastCost: lastCost, historicalCost: historicalCost)

    }
    
    func dataForMainScreen(mainCurrency: String) -> [Currency] {
        
        var mainScreenData = [Currency]()
        let keys = [ "RUB" , "USD", "EUR"]
        for key in keys{
            if let cur = currencies[key] {
                mainScreenData.append(Currency(name: cur.nameShort, nameFull: cur.nameFull, cost: cur.lastCost[mainCurrency] ?? 0, photo: UIImage(imageLiteralResourceName: cur.photo)))
            }
        }
        
        return mainScreenData
    }
    
    func getDataForDetails(firstCurrency: String, secondCurrency: String) -> (Currency, Currency, [String : Double] ){
        
        let first = self.currencies[firstCurrency]
        var image = UIImage(systemName: "photo")
        if let imageName = first?.photo {
            image = UIImage(imageLiteralResourceName: imageName)
        }
        let firstData = Currency(name: first?.nameShort ?? "", nameFull: first?.nameFull ?? "" , cost: first?.lastCost[firstCurrency] ?? 1, photo: image!)
        
        let second = self.currencies[secondCurrency]
        image = UIImage(systemName: "photo")
        if let imageName = second?.photo {
            image = UIImage(imageLiteralResourceName: imageName)
        }
        let secondData = Currency(name: second?.nameShort ?? "", nameFull: second?.nameFull ?? "" , cost: second?.lastCost[firstCurrency] ?? 1, photo: image!)
        
        print(self.currencies[firstCurrency])
        
        let chartData = self.currencies[secondCurrency]?.historicalCost[firstCurrency] ?? [:]
        
        return (firstData, secondData, chartData)
        
    
    }

}

