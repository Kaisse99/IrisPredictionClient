//
//  IrisViewModels.swift
//  IrisPredictionClient
//
//  Created by Mykyta Kaisenberg on 2026-03-23.
//

import Foundation
internal import Combine

let address : String = "http://127.0.0.1:5000/predict"

@MainActor
class IrisViewModel : ObservableObject {
   
    @Published var sepalLength = ""
    @Published var sepalWidth = ""
    @Published var petalLength = ""
    @Published var petalWidth = ""
    
    @Published var prediction: Int? = nil
    
    @Published var isLoading = false
    
    @Published var errorMessage = ""
    
    func predict() async {
        isLoading = true
        
        guard let S_length = Double(sepalLength) else {
            errorMessage = "Sepal Length format is incorrect."
            isLoading = false
            return
        }
        
        guard let S_width = Double(sepalWidth) else {
            errorMessage = "Sepal Width format is incorrect."
            isLoading = false
            return
        }
        
        guard let P_length = Double(petalLength) else {
            errorMessage = "Petal Length format is incorrect."
            isLoading = false
            return
        }
        
        guard let P_width = Double(petalWidth) else {
            errorMessage = "Petal Width format is incorrect."
            isLoading = false
            return
        }
        
        let body = PredictRequest(features: [S_length, S_width, P_length, P_width])
        
        let url = URL(string: address)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            errorMessage = "Something went wrong during encoding data into JSON format."
            print("Error encoding JSON: \(error)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(PredictResponse.self, from: data)
            prediction = response.prediction
            
        } catch {
            errorMessage = "Something went wrong during sending a request or recieving responseto: \(address)"
            isLoading = false
            return
        }
        isLoading = false
        
        
    }
    
}
