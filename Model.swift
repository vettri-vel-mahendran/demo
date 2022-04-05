//
//  Model.swift
// Zeno
//
//  Created by apple on 03/12/21.
//

import Foundation
import UIKit
import CoreBluetooth

//MARK: - Mesh sm Measurement Model
struct meshsmMeasurementModel : Codable{
    var Distance: [String]
    var Time: String
    var Remarks: [String]
    var ImageData: Data
}

//MARK: - sm Measurement Model
struct smMeasurementModel : Codable{
    var Distance: String
    var Time: String
    var Remarks: String
    var ImageData: Data
}

//MARK: - cm Measurement Model
struct cmMeasurementModel : Codable{
    var Distance: String
    var Time: String
    var Remarks: String
    var ImageData: Data
}
//MARK: - al Measurement Model
struct alMeasurementModel : Codable{
    var Distance: String
    var Time: String
    var Remarks: String
    var X: String
    var Y: String
    var Z: String
    var ImageData: Data
}
//MARK: - sf Measurement Model
struct sfMeasurementModel : Codable{
    var Distance: String
    var Time: String
    var Remarks: String
    var X: String
    var Y: String
    var Z: String
    var ImageData: Data
}
//MARK: -Ble Devices Model
struct BleDevicesModel: Hashable{
    var NetworkID: String
    var peri: CBPeripheral?
    var DeviceId: String
    var btpercent: String?
}
