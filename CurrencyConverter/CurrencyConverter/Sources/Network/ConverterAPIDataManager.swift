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
    
    private var api_key = ""
    
    init() {
        print("key")
        getKey()
        print(self.api_key)
    }
    
    func updateData<T: Decodable>(currancyPair pair: String, type: RequaestType, completion: @escaping (T?, ErrorModel?) -> ()) {
        var url = "\(pair)?apikey=\(api_key)"
        switch type {
        case .actualPrice: url = Requests.udateCost + url
        case .historical: url = Requests.historicalData + url
        }
        self.fetchApiData(urlString: url, completion: completion)
    }

}

private extension ConverterAPIDataManager {
    
    private func getKey() {
        let path = Bundle.main.path(forResource: "key", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        for dataObject in listArray {
            if let keyInfo = dataObject as? String {
                self.api_key = keyInfo
            }
        }
    }
    
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

