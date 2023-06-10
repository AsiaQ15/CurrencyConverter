//
//  DetailsData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import Foundation
import UIKit

final class DetailsData {
    
    private var currencyFirst =  Currency(name: "first", nameFull: "", cost: 0, photo: UIImage(systemName: "photo")!)
    private var currencySecond = Currency(name: "first", nameFull: "", cost: 0, photo: UIImage(systemName: "photo")!)
    
    private var chart = [String : Double]()
    
    func setData(first: Currency, second: Currency, chart: [String : Double]) {
        self.currencyFirst.name = first.name
        self.currencyFirst.cost = first.cost
        self.currencyFirst.photo = first.photo
        self.currencySecond.name = second.name
        self.currencySecond.cost = second.cost
        self.currencySecond.photo = second.photo
        self.chart = chart
        
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
    
    func getFirstCount() -> Double {
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
    
    func getNewSecondCout(value: Double) -> Double {
        Double(round(1000 * value / currencySecond.cost) / 1000)
    }
    
    func getSecondCount() -> Double {
        currencyFirst.cost
    }
    
    func getScreenName() -> String {
        "\(currencyFirst.name) \(currencySecond.name)"
    }
    
    func getChartData() -> ([String], [Double], String) {
        var dates = [String]()
        for key in self.chart.keys {
            dates.append(String(key))
        }
        var cost = [Double]()
        for val in self.chart.values {
            cost.append(Double(val))
        }
        return (dates, cost, getScreenName())
    }

}
