//
//  BeaconViewModel.swift
//  UbahnStationWegbeschreibung
//
//  Created by Lukas Carvajal on 7/30/23.
//

import Foundation

class BeaconViewModel: ObservableObject {
    @Published var beacon = Beacon()
    
    func getBeacon(uuid: UUID) {
        if self.beacon.station != "" { return }
        
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
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                print(error.localizedDescription)
            } else if let data = data {
                // Handle HTTP request response
    //            let outputStr  = String(data: data, encoding: String.Encoding.utf8)
    //            print(outputStr)
                DispatchQueue.main.async {
                    if let beacon = try? JSONDecoder().decode([Beacon].self, from: data) {
                        self.beacon = beacon[0]
                    }
                    else {
                        print("Unable to decode JSON response")
                    }
                }
            } else {
                // Handle unexpected error
            }
        }.resume()
    }
}
