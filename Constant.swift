//
//  Constant.swift
// Zeno
//
//  Created by apple on 27/11/21.
//

import Foundation
import UIKit

//MARK: screen sizes
let FULL_WIDTH = UIScreen.main.bounds.size.width
let FULL_HEIGHT = UIScreen.main.bounds.size.height

//MARK: Device Models
let IS_IPHONE_X = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
let IS_IPHONE_XR = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1624

let IS_IPHONE_PLUS = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 2208 || UIScreen.main.nativeBounds.height == 1920)
let IS_IPHONE_678 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1334)
let IS_IPHONE_5 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1136)

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

//MARK: Measurement Type
enum MeasurementType {
    case MeshSM
    case SM
    case CM
    case AL
    case SF
}

//MARK: BenchMarkMode
enum BenchMarkMode : Codable{
    case FrontBenchMark
    case BackBenchMark
}

//MARK: DeviceMode
enum DeviceMode : Codable{
    case SingleDeviceMode
    case MultiDeviceMode
}

//MARK: SettingMenu
enum SettingMenu : Codable{
    case Calculator
    case Calendar
    case ConfigureDevices
    case Conversion
    case DeviceSettings
    case DrawingMode
    case ReportAnalysis
    case Report
    case StopWatch
    case SurfaceFlatness
}
