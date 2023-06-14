//
//  ConverterAPIDataManager.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 10.06.2023.
//

import Foundation

enum RequaestType {
    case actualPrice
    case historical
}

private enum Requests {
    static let udateCost = "https://financialmodelingprep.com/api/v3/quote/"
    static let historicalData = "https://financialmodelingprep.com/api/v3/historical-price-full/"
}

final class ConverterAPIDataManager {
    
    static let shared = ConverterAPIDataManager()
    
    private let api_key = "c634dac2ed75bec4e079d45961638b21"
    //"0d3c2d8abf0034710417d5c6878c521c"
    
    func updateData<T: Decodable>(currancyPair pair: String, type: RequaestType, completion: @escaping (T?, ErrorModel?) -> ()) {
        var url = "\(pair)?apikey=\(api_key)"
        switch type {
        case .actualPrice: url = Requests.udateCost + url
        case .historical: url = Requests.historicalData + url
        }
        self.fetchApiData(urlString: url, completion: completion)
    }
    
    
//    func historicalData(currancyPair pair: String) {
//        //let pair = "JPYUSD"
//        let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/forex/\(pair)?apikey=\(api_key)")
//
//        var request = URLRequest(url: url!)
//
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json)
//        }
//
//        task.resume()
//    }
//
//    func updateCost(currancyPair pair: String) {
//
//        let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-chart/4hour/\(pair)?apikey=\(api_key)")
//
//        var request = URLRequest(url: url!)
//
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json)
//        }
//
//        task.resume()
//    }

}

private extension ConverterAPIDataManager {
    
    private func fetchApiData<T: Decodable>(urlString: String, completion: @escaping (T?, ErrorModel?) -> ()) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to get data:", err)
                return
            }
            if let error = self.checkResponse(response: response, data: data) {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            if let responseData: T = self.handleSuccess(data: data) {
                DispatchQueue.main.async {
                    completion(responseData, nil)
                }
            }
        }.resume()

    }
    
    private func handleSuccess<T: Decodable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch let jsonErr {
            print("Failed to serialize json:", jsonErr)
        }
        return nil
    }
    
    private func checkResponse(response: URLResponse?, data: Data?) -> ErrorModel? {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let error = self.errorHandle(httpResponse: httpResponse, data: data)
                return error
            }
        }
        return nil
    }
    
    private func errorHandle(httpResponse: HTTPURLResponse, data: Data?) -> ErrorModel? {
        print("Status code: \(httpResponse.statusCode)")
        var error: ErrorModel?
        guard let data = data else { return nil }
        do {
            error = try JSONDecoder().decode(ErrorModel.self, from: data)
        }
        catch let jsonErr {
            print("Failed to serialize error in json:", jsonErr)
        }
        print("Error code : \(error?.Code ?? "")")
        print("Message : \(error?.Message ?? "")")
        return error
    }
}


