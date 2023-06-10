//
//  APIModel.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

//import Foundation

struct PricePair: Decodable {
    let ticker: String
    let bid: Double
    let open: Double
    let low: Double
    let high: Double
    let changes: Double
    let date: String
}

struct PriceHistorical: Decodable {
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

struct HistoricalData: Decodable {
    let symbol : String
    let  historical : [PriceHistorical]
}

struct ErrorModel: Decodable {
    let Code: String?
    let Message: String?
}
