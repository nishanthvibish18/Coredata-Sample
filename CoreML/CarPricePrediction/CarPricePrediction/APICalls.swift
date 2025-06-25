//
//  APICalls.swift
//  CarPricePrediction
//
//  Created by NishanthVibishKavi on 6/25/25.
//

import Foundation

struct PricePredictionResponse: Decodable{
    let price: Double
}


struct HTTPClient{
    func predictPrice(year: Double, miles: Double, nameEncode: Double) async throws -> Double{
        let url = URL(string: "http://127.0.0.1:8080/api/car-price")!
        let body = ["miles":miles,"year":year,"nameEncodedValue":nameEncode]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody  = try JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let predictPrice = try JSONDecoder().decode(PricePredictionResponse.self, from: data)
        return predictPrice.price
        
    }
}

//"miles":1500,
//    "year":2019,
//    "":7
