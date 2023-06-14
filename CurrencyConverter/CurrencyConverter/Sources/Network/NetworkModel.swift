//
//  APIModel.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

struct PricePair: Decodable {
    let symbol: String
    let name: String
    let price: Double?
    let changesPercentage: Double?
    let change: Double?
    let dayLow: Double?
    let dayHigh: Double?
    let yearHigh: Double?
    let yearLow: Double?
    let marketCap: Double?
    let priceAvg50: Double?
    let priceAvg200: Double?
    let exchange: String
    let volume: Double?
    let avgVolume: Double?
    let open: Double?
    let previousClose: Double?
    let eps: Double?
    let pe: Double?
    let earningsAnnouncement: Double?
    let sharesOutstanding: Double?
    let timestamp: Double?
}

struct PriceHistorical: Decodable {
    let date: String
    let open: Double?
    let high: Double?
    let low: Double?
    let close: Double?
    let adjClose: Double?
    let volume: Double?
    let unadjustedVolume: Double?
    let change: Double?
    let changePercent: Double?
    let vwap: Double?
    let label: String
    let changeOverTime: Double?
}

struct HistoricalData: Decodable {
    let symbol : String
    let  historical : [PriceHistorical]
}

struct ErrorModel: Decodable {
    let Code: String?
    let Message: String?
}

