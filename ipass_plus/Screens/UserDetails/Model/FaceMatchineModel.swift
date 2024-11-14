// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let faceMatchingModel = try? JSONDecoder().decode(FaceMatchingModel.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FaceMatchingModel: Codable {
    let status: Bool
    let message: String
    let data: FaceMatchingDataClass
}

// MARK: - DataClass
struct FaceMatchingDataClass: Codable {
    let facePercentage: Int
}


// MARK: - Welcome
struct FaceLiveNessModel: Codable {
    let status: Bool
    let message: String
    let data: FaceLivenessDataClass
}

// MARK: - DataClass
struct FaceLivenessDataClass: Codable {
    let isAlive: Bool
}
