//
//  Test.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

import Foundation

private struct PricePair: Decodable {
    let date: String
    let open: Double
    let low: Double
    let high: Double
    let close: Double
    let volume: Double
}

private struct PriceHistorical: Decodable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let adjClose: Double
    let volume: Double
    let unadjustedVolume: Double
    let change: Double
    let changePercent: Double
    let vwap: Double
    let label: String
    let changeOverTime: Double
}

private struct HistoricalData: Decodable {
    let symbol : String
    let  historical : [PriceHistorical]
}



final class DataPrice {
    
   // private var prices: [PricePair] = []
    private static let fileNameUpdate = "now"
    private static let fileName2 = "historical"
    
    func loadJson() {
        if let url = Bundle.main.url(forResource: DataPrice.fileNameUpdate, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([PricePair].self, from: data)
          
                print(jsonData[0])
//                for price in jsonData {
//                    print(price)
//                }
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func loadJson2() {
        if let url = Bundle.main.url(forResource: DataPrice.fileName2, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(HistoricalData.self, from: data)
          
                print(jsonData.symbol)
                print(jsonData.historical)
//                for price in jsonData {
//                    print(price)
//                }
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    
    
    
}
