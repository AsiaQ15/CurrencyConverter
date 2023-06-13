//
//  MainScreenData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit

struct Currency {
    var name: String
    var nameFull: String
    var cost: Double
    var photo: UIImage
    
}

final class MainScreenModel {
    private var currencies = [Currency]()
    private var mainCurrency = "RUB"
    
    init() {
        //self.addData()
    }
    
    func currencyCount() -> Int {
        self.currencies.count
    }
    
    func addData() {
        currencies.append(Currency(name: "RUB",nameFull: "Российский рубль", cost: 1.0, photo: UIImage(imageLiteralResourceName: "RUB.jpg") ))
        currencies.append(Currency(name: "USD",nameFull: "Евро", cost: 88.88, photo: UIImage(imageLiteralResourceName: "USD.jpg") ))
        currencies.append(Currency(name: "EUR",nameFull: "Доллар США", cost: 87.10, photo: UIImage(imageLiteralResourceName: "EUR.jpg") ))
    }
    
    func getData(_ id: Int) -> Currency {
        currencies[id]
    }
    
    func setData(_ data: ([Currency], String)) {
        self.currencies = data.0
        self.mainCurrency = data.1
    }
    
    func setMainCurrency(currency: String) {
        self.mainCurrency = currency
    }
    
    func getMainCurrency() -> String {
        self.mainCurrency
    }
    
    func changeMainCurrency(index: Int) {
        let reserv = self.currencies.remove(at: index)
        self.currencies.insert(reserv, at: 0)
        
        self.mainCurrency = reserv.name
    }
}


