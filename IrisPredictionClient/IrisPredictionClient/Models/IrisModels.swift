//
//  IrisModels.swift
//  IrisPredictionClient
//
//  Created by Mykyta Kaisenberg on 2026-03-23.
//

import Foundation

struct PredictRequest : Encodable {
    let features : [Double]
}

struct PredictResponse : Decodable {
    let prediction : Int
}
