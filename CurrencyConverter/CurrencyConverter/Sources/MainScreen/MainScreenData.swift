//
//  MainScreenData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import Foundation

struct Currency {
    var name: String
    var cost: Float
    
}

final class CurrencyData {
    private var currencies = [Currency]()
    
    init() {
        self.addData()
    }
    
    func currencyCount() -> Int {
        self.currencies.count
    }
    
    func addData() {
        currencies.append(Currency(name: "RUB", cost: 1.0))
        currencies.append(Currency(name: "USD", cost: 88.88))
        currencies.append(Currency(name: "EUR", cost: 87.10))
    }
    
    func getData(_ id: Int) -> Currency {
        currencies[id]
    }
}


