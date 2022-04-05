//
//  Config.swift
//  DemoWorkProject
//
//  Created by apple on 22/11/21.
//

import Foundation
import UIKit
import CoreBluetooth

let APP_NAME = "ZENO"

//MARK: Configure Color
let PRIMARY_COLOR = UIColor(named: "PRIMARY_COLOR")!
let CELL_BG_COLOR = UIColor(named: "CELL_BG_COLOR")!
let TEXT_COLOR = UIColor(named: "TEXT_COLOR")!

//MARK: Configure Font
let APP_REGULAR_FONT = "OpenSans-Regular"
let APP_SEMI_BOLD_FONT = "OpenSans-SemiBold"
let APP_BOLD_FONT = "OpenSans-Bold"

//MARK: Configure Language
let DEFAULT_LANGUAGE = "English"

//MARK: Global Config
var SelectedBle: BleDevicesModel?
var MeshDeviceCount : Int = 0

//MARK: Configure  Data Byte
var MeshHeader1: UInt8 = 0xaa
var MeshHeader2: UInt8 = 0x13

var Sequence1: UInt8 = 0x00
var Sequence2: UInt8 = 0x00
var Sequence3: UInt8 = 0x00
var Sequence4: UInt8 = 0x00

var TTL: UInt8 = 0x04

var SourceAddress1: UInt8 = 0xee
var SourceAddress2: UInt8 = 0xff
var SourceAddress3: UInt8 = 0xee
var SourceAddress4: UInt8 = 0xff

var DeviceId: UInt8 = 0x02
var NetworkId: UInt8 = 0x00
var DeviceName: UInt8 = 0x18

var DeviceId1: UInt8 = 0
var DeviceId2: UInt8 = 0
var DeviceId3: UInt8 = 0
var DeviceId4: UInt8 = 0

var NetworkId1: UInt8 = 0
var NetworkId2: UInt8 = 0
var NetworkId3: UInt8 = 0
var NetworkId4: UInt8 = 0
