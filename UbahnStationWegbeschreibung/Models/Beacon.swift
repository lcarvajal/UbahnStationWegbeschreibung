//
//  Beacon.swift
//  UbahnStationWegbeschreibung
//
//  Created by Lukas Carvajal on 7/29/23.
//

import Foundation

struct BeaconsResponse: Decodable {
    let results: [Beacon]
}

struct Beacon: Decodable {
    let uuid: String
    let station: String
    let description: String
}

func getBeacon(uuid: UUID) {
    // Encode your JSON data
    let jsonString = "{ \"uuid\" : \"\(uuid.uuidString)\" }"
    guard let jsonData = jsonString.data(using: .utf8) else { return }

    // Send request
    guard let url = URL(string: "https://coding-austria-2023.onrender.com/api/beacons") else { return }
        
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    print("Making a request: \(url)")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            // Handle HTTP request error
            print(error.localizedDescription)
        } else if let data = data {
            // Handle HTTP request response
            let outputStr  = String(data: data, encoding: String.Encoding.utf8)
            print(outputStr)
        } else {
            // Handle unexpected error
        }
    }
    task.resume()
}

