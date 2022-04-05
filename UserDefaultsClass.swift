//
//  UserDefaultsClass.swift
//  DemoWorkProject
//
//  Created by apple on 22/11/21.
//

import Foundation
import CoreBluetooth

class UserDefaultsClass {
    static let shared = UserDefaultsClass()
    
    //MARK: set Bluetooth Status
    func setBluetoothStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "BluetoothStatus")
    }
    
    //MARK: get Bluetooth Status
    func getBluetoothStatus() -> Bool {
        if (UserDefaults.standard.value(forKey: "BluetoothStatus") != nil){
            return UserDefaults.standard.value(forKey: "BluetoothStatus") as! Bool
        }
        return false
    }
    
    //MARK: set Sequence
    func setSequence(withSequence: String) {
        UUidArray = UserDefaultsClass.shared.getUUidArray()
        if SelectedBle?.peri != nil {
            UUidArray[(SelectedBle?.peri?.identifier.uuidString)!] = withSequence
        }
        UserDefaultsClass.shared.setUUidArray(status: UUidArray)
        UserDefaults.standard.set(withSequence, forKey: "Sequence")
    }
    
    //MARK: get Sequence Status
    func getSequence() -> String {
        if (UserDefaults.standard.value(forKey: "Sequence") != nil){
            return UserDefaults.standard.value(forKey: "Sequence") as! String
        }
        return ""
    }
    
    //MARK: set Splash Status
    func setSplashStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "SplashStatus")
    }
    
    //MARK: get Splash Status
    func getSplashStatus() -> Bool {
        if (UserDefaults.standard.value(forKey: "SplashStatus") != nil){
            return UserDefaults.standard.value(forKey: "SplashStatus") as! Bool
        }
        return false
    }
    
    //MARK: set app language
    func setAppLanguage(Language: String){
        UserDefaults.standard.set(Language, forKey: "language_name")
    }
    
    //MARK: get app language
    func getAppLanguage() -> String? {
        return UserDefaults.standard.value(forKey: "language_name") as? String
    }
    
    //MARK: set Device Mode
    func setDeviceMode(Mode: DeviceMode){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(Mode), forKey: "DeviceMode")
    }
    
    //MARK: get Device Mode
    func getDeviceMode() -> DeviceMode? {
        if let data = UserDefaults.standard.value(forKey: "DeviceMode") as? Data {
            return  (try? PropertyListDecoder().decode(DeviceMode.self, from: data))
        } else {
            return nil
        }
    }
    
    //MARK: set BenchMode
    func setBenchMode(Mode: BenchMarkMode){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(Mode), forKey: "BenchMarkMode")
    }
    
    //MARK: get Mode
    func getBenchMode() -> BenchMarkMode? {
        if let data = UserDefaults.standard.value(forKey: "BenchMarkMode") as? Data {
            return  (try? PropertyListDecoder().decode(BenchMarkMode.self, from: data))
        } else {
            return nil
        }
    }
    
    //MARK: set App language Dict
    func setLanguageDict(languageDict: NSDictionary){
        UserDefaults.standard.set(languageDict, forKey: "app_language")
    }
    
    //MARK: get App language Dict
    func getLanguageDict() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "app_language") as? NSDictionary
    }
    
    //MARK: set ProjectId
    func setProjectId(projectid: String){
        UserDefaults.standard.set(projectid, forKey: "project_id")
    }
    
    //MARK: get ProjectId
    func getProjectId() -> String? {
        return UserDefaults.standard.value(forKey: "project_id") as? String
    }
    
    //MARK: set UUidArray
    func setUUidArray(status: [String : String]) {
        UserDefaults.standard.set(status, forKey: "UUidArray")
    }
    
    //MARK: get UUidArray
    func getUUidArray() -> [String : String] {
        if (UserDefaults.standard.value(forKey: "UUidArray") != nil){
            return UserDefaults.standard.value(forKey: "UUidArray") as! [String : String]
        }
        return [String : String]()
    }
}
