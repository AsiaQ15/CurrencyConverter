//
//  DetailsData.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import Foundation
import UIKit

final class DetailsData {
    
    private var currencyFirst =  Currency(name: "", nameFull: "", cost: 0, photo: UIImage(systemName: "photo")!)
    private var currencySecond = Currency(name: "", nameFull: "", cost: 0, photo: UIImage(systemName: "photo")!)
    
    private var chart = ([String](),[Double]())
    private var coef = 1.0
    
    func setData(first: Currency, second: Currency, chart: ([String],[Double])) {
        self.currencyFirst = first
        self.currencySecond = second
        self.chart = chart
        self.coef = second.cost
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
        Double(round(1000 * currencySecond.cost) / 1000)
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
        let newSecondCount = Double(round(1000 * value / currencySecond.cost) / 1000)
        self.coef = value
        return newSecondCount
    }
    
    func getCoef() -> Double {
        self.coef
    }
    
    func getSecondCount() -> Double {
        Double(round(1000 * currencyFirst.cost) / 1000)
    }
    
    func getScreenName() -> String {
        "\(currencyFirst.name) \(currencySecond.name)"
    }
    
    func getChartData() -> ([String], [Double], String, Double) {
        (self.chart.0, self.chart.1, getScreenName(), self.coef)
    }
    
    func swap() {
        let reserv = self.currencyFirst
        self.currencyFirst = self.currencySecond
        self.currencySecond = reserv
        self.currencySecond.cost = Double( round (10000 / self.currencyFirst.cost) / 10000)
        self.currencyFirst.cost = 1.0
        self.chart.1 = self.chart.1.map{1.0/$0}
        self.coef = self.currencySecond.cost
    }

}

