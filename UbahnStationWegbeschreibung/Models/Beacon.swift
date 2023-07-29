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
    var uuid: String = ""
    var station: String = ""
    var description: String = ""
}
