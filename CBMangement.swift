//
//  CBMangement.swift
//  Zeno
//
//  Created by apple on 07/01/22.
//

import Foundation
import CoreBluetooth

var manager:CBCentralManager?
var WriteCharacteristic : CBCharacteristic?
var ReadCharacteristic : CBCharacteristic?
var WriteCount = 0

final class BleManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    var GetdataReceived: ((_ str: String) -> Void)?
    var GetPeripheral: ((_ peripheral: CBPeripheral, _ NetworkId: String, _ DeviceId: String, _ btpercent: String) -> Void)?
    var PeripheralConnected: ((_ peripheral: CBPeripheral) -> Void)?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        SelectedBle?.peri?.delegate = self
        manager?.delegate = self
    }
    
    //MARK: StartScanning
    func startScanning() {
        manager!.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    //MARK: stopScanning
    func stopScanning() {
        manager!.stopScan()
    }
    
    //MARK: discoverServices
    func discoverServices(){
        guard SelectedBle?.peri == nil else {
            SelectedBle?.peri?.delegate = self
            manager?.delegate = self
            SelectedBle?.peri!.discoverServices(nil)
            return
        }
    }
    
    //MARK: Connect
    func Connect() {
        WriteCount = 0
        guard SelectedBle?.peri == nil else {
            manager!.connect((SelectedBle?.peri!)!, options: nil)
            return
        }
    }
    
    //MARK: DisConnect
    func DisConnect() {
        guard SelectedBle?.peri == nil else {
            manager!.cancelPeripheralConnection((SelectedBle?.peri!)!)
            return
        }
    }
}

//MARK: - CBPeripheralDelegate
extension BleManager: CBPeripheralDelegate {
    
    //MARK: centralManagerDidUpdateState
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print("CBManager is powered on")
            UserDefaultsClass.shared.setBluetoothStatus(status : true)
        case .poweredOff:
            print("CBManager is not powered off")
            UserDefaultsClass.shared.setBluetoothStatus(status : false)
            return
        case .resetting:
            print("CBManager is resetting")
            return
        case .unauthorized:
            return
        case .unknown:
            print("CBManager state is unknown")
            return
        case .unsupported:
            print("Bluetooth is not supported on this device")
            return
        @unknown default:
            print("A previously unknown central manager state occurred")
            return
        }
    }
    
    //MARK: didDiscoverPeripheral
    func centralManager(_ central: CBCentralManager, didDiscover  peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // Reject if the signal strength is too low to attempt data transfer.
        // Change the minimum RSSI value depending on your app’s use case.
        //                guard RSSI.intValue >= -50
        //                    else {
        //                        print("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
        //                        return
        //                }
        
        //                print("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)
        
        let ServiceDataDict: NSDictionary? = advertisementData[CBAdvertisementDataServiceDataKey] as? NSDictionary
        if ServiceDataDict != nil {
            let ServiceData :Data = (ServiceDataDict!.allValues)[0] as! Data
            let ServiceDataString = ServiceData.hexEncodedString()
            
            if ServiceDataString.count == 32{
                let start = ServiceDataString.index(ServiceDataString.startIndex, offsetBy: 8)
                let end = ServiceDataString.index(ServiceDataString.endIndex, offsetBy: -16)
                let range = start..<end
                let deviceId = ServiceDataString[range]
                
                let start2 = ServiceDataString.index(ServiceDataString.startIndex, offsetBy: 16)
                let end2 = ServiceDataString.index(ServiceDataString.endIndex, offsetBy: -8)
                let range2 = start2..<end2
                let networkId = ServiceDataString[range2]
                
                let ManufacturerDataDict = advertisementData[CBAdvertisementDataManufacturerDataKey]
                if ManufacturerDataDict != nil {
                    let ManufacturerData :Data = ManufacturerDataDict! as! Data
                    let ManufacturerDataString = ManufacturerData.hexEncodedString()
                    
                    if ManufacturerDataString.count < 10 {
                        let btpercent = Int(ManufacturerDataString.dropFirst(4), radix: 16)! //remove prefix ffff
                        self.GetPeripheral?(peripheral, String(networkId), String(deviceId) ,String(btpercent))
                    }
                }
            }
        }
        
    }
    
    //MARK: didDiscoverServices
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: %s", error.localizedDescription)
            return
        }
        
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    //MARK: didConnectPeripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.PeripheralConnected!(peripheral)
    }
    
    //MARK: didFailToConnectPeripheral
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to ", peripheral, String(describing: error))
    }
    
    //MARK: didDisconnectPeripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let DataDict:[String: String] = ["Pheripheral": (peripheral.name ?? "Pheripheral")]
        NotificationCenter.default.post(name: NSNotification.Name("PheripheralDisconnected"), object: nil, userInfo: DataDict)
        SelectedBle?.peri = nil
    }
    
    //MARK: didDiscoverCharacteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: ", error.localizedDescription)
            return
        }
        
        guard let serviceCharacteristics = service.characteristics else { return }
        
        for characteristic in serviceCharacteristics  {
            if characteristic.properties.contains(.read) {
                self.readValue(characteristic: characteristic)
                ReadCharacteristic = characteristic
            } else if characteristic.properties.contains(.notify){
                subscribeToNotifications(peripheral: (SelectedBle?.peri!)!, characteristic: characteristic)
            } else if characteristic.properties.contains(.write) {
                WriteCharacteristic = characteristic
            } else if characteristic.properties.contains(.writeWithoutResponse) {
                WriteCharacteristic = characteristic
            }
        }
    }
    
    //MARK: func write value
    func write(value: Data, characteristic: CBCharacteristic) {
        print("\n Written HexString \n", value.hexEncodedString())
        print("\n Written AsciiString \n", (value.hexEncodedString()).hexStringtoAscii())
        WriteCount  =  WriteCount + 1
        print("\n Write Count \n", WriteCount)
        if WriteCount > 5 {
            NotificationCenter.default.post(name: NSNotification.Name("ResetDevice"), object: nil)
        }
        SelectedBle?.peri?.writeValue(value, for: characteristic, type: .withoutResponse)
    }
    
    //MARK: didWriteValueFor
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print(error?.localizedDescription ?? "")
            return
        }
    }
    
    //MARK: func readValue
    func readValue(characteristic: CBCharacteristic) {
        SelectedBle?.peri?.readValue(for: characteristic)
    }
    
    //MARK: didUpdateValueFor
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let WholeData = (characteristic.value!)
        let dropedData = WholeData.dropFirst(6)
        let hexstr = dropedData.hexEncodedString()
        let ReceievedVal = hexstr.hexStringtoAscii()
        print("\n Receieved HexString \n",hexstr)
        print("\n Receieved AciiString \n",ReceievedVal)
        if ReceievedVal.contains("{") {
            WriteCount = 0
        }
        self.GetdataReceived?(ReceievedVal)
    }
    
    //MARK: func subscribeToNotifications
    func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    //MARK: func didUpdateNotificationStateFor
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
}
