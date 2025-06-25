//
//  ContentView.swift
//  CarPricePrediction
//
//  Created by NishanthVibishKavi on 6/22/25.
//

import SwiftUI
import CoreML

struct CarMappingModel: Codable, Identifiable, Hashable{
    let name:String
    let id: Int
}


struct ContentView: View {
    @State private var carData: [CarMappingModel] = []
    @State private var selectedCarMapping: CarMappingModel?
    @State private var year: Double?
    @State private var miles: Double?
    @State private var predictPrice: Double?
    
    private var isFormValid: Bool {
        return selectedCarMapping != nil && year != nil && miles != nil
    }
    
    private func standardizeMiles(_ miles: Double) -> Double {
        let mean = 5445.69731818182
        let st_dev = 25685.350148367597
        return (miles - mean) / st_dev
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green.opacity(0.6), .blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Car Price Predictor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    // Car Picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Car")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Picker("Select Car", selection: $selectedCarMapping) {
                            ForEach(carData) { data in
                                Text(data.name)
                                    .tag(data as CarMappingModel?)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    // Year Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter Year")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Year", value: $year, formatter: NumberFormatter.plainNumbers)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    // Miles Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter Miles")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Miles", value: $miles, formatter: NumberFormatter.plainNumbers)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    // Predict Button
                    Button {
                        Task {
                            await self.apiCallData()
                        }
                        
                    } label: {
                        Text("Predict Price")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.green : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    
                    // Prediction Result
                    if let predictedPrice = predictPrice {
                        VStack {
                            Text("Predicted Price")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(predictedPrice, format: .currency(code: "USD"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            self.carData = self.loadCarDatas()
        }
    }
    
    private func getData() async{
        await apiCallData()
        //        predictPriceAction()
    }
    
    private func apiCallData() async{
        let httpClient = HTTPClient()
        guard let selectedCar = selectedCarMapping?.id, let years = year, let mile = miles else {
            return
        }
        do{
            self.predictPrice = try await httpClient.predictPrice(year: years, miles: mile, nameEncode: Double(selectedCar))
        }
        catch{
            print("error:::\(error.localizedDescription)")
        }
    }
    private func predictPriceAction() {
        let model = try! Carvana(configuration: MLModelConfiguration())
        
        guard let selectedCar = selectedCarMapping?.id, let years = year, let mile = miles else {
            return
        }
        
        let standardizedMiles = self.standardizeMiles(mile)
        
        do {
            let predictModelData = try model.prediction(Year: years, Miles: standardizedMiles, Name_encoded: Double(selectedCar))
            
            self.predictPrice = predictModelData.Price
        } catch {
            print("Prediction error: \(error.localizedDescription)")
        }
    }
    
    private func loadCarDatas() -> [CarMappingModel] {
        let carjsonFile = "car_name_mapping"
        guard let bundleId = Bundle.main.url(forResource: carjsonFile, withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: bundleId)
            let rawDictionary = try JSONDecoder().decode([String: Int].self, from: data)
            
            return rawDictionary.map { CarMappingModel(name: $0.key, id: $0.value) }.sorted { $0.id < $1.id }
            
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}


#Preview {
    ContentView()
}


extension NumberFormatter{
    static var plainNumbers: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .decimal
        return formatter
    }
}
