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
    private var mainCurrency = ""
    
    func currencyCount() -> Int {
        self.currencies.count
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

