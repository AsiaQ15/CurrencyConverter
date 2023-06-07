//
//  DetailsData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import Foundation
import UIKit

final class DetailsData {
    
    private var currencyFirst =  Currency(name: "first", cost: 0, photo: UIImage(systemName: "photo")!)
    private var currencySecond = Currency(name: "first", cost: 0, photo: UIImage(systemName: "photo")!)
    
    func setData(first: Currency, second: Currency) {
        currencyFirst.name = first.name
        currencyFirst.cost = first.cost
        currencyFirst.photo = first.photo
        currencySecond.name = second.name
        currencySecond.cost = second.cost
        currencySecond.photo = second.photo
        
    }
    
    func getFistName() -> String {
        currencyFirst.name
    }
    
    func getFirstCostString() ->String {
        let cost = String(format: "%.4f", currencyFirst.cost/currencySecond.cost)
        return "1 \(currencyFirst.name) = \(cost) \(currencySecond.name)"
    }
    
    func getFirstImage() -> UIImage {
        currencyFirst.photo
    }
    
    func getFirstCount() -> Float {
        currencySecond.cost
    }
    
    func getSecondName() -> String {
        currencySecond.name
    }
    
    func getSecondCostString() ->String {
        let cost = String(format: "%.4f", currencySecond.cost/currencyFirst.cost)
        return "1 \(currencySecond.name) = \(cost) \(currencyFirst.name)"
    }
    
    func getSecondImage() -> UIImage {
        currencySecond.photo
    }
    
    func getNewSecondCout(value: Float) -> Float {
        Float(round(1000 * value / currencySecond.cost) / 1000)
    }
    
    func getSecondCount() -> Float {
        currencyFirst.cost
    }
    
    func getScreenName() -> String {
        "\(currencyFirst.name) \(currencySecond.name)"
    }

}
