//
//  Utility.swift
//  DemoWorkProject
//
//  Created by apple on 22/11/21.
//

import Foundation
import UIKit
import PopupDialog
import FTPopOverMenu_Swift
import CoreBluetooth
import Toast_Swift
import BSImagePicker
import Photos

class Utility{
    static let shared = Utility()
    
    //MARK: Configure app language
    func configureLanguage()  {
        if let path = Bundle.main.path(forResource:UserDefaultsClass.shared.getAppLanguage(), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                UserDefaultsClass.shared.setLanguageDict(languageDict: jsonResult as! NSDictionary)
            } catch {
                // handle error
            }
        }
    }
    
    //MARK:  Translate Text
    func TranslatedTextOf(text:String) -> String {
        return  UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String ?? text
    }
    
    //MARK:  Turn On Bluetooth Alert
    func AlertNoBlueTooth(VC: UIViewController){
        let popup = PopupDialog(title: "\(Bundle.main.infoDictionary!["CFBundleName"] as! String) Would like to use Bluetooth", message: "Kindly Turn On Bluetooth", image: UIImage())
        
        let buttonOkAY = CancelButton(title: "Okay") { }
        popup.addButtons([buttonOkAY])
        VC.present(popup, animated: true, completion: nil)
    }
    
    //MARK:  Get Next SequenceOfByte
    func getnextSequence(){
        let str = UserDefaultsClass.shared.getSequence()
        let len = str.lengthOfBytes(using: String.Encoding.utf8)
        let num2 = Int(str, radix: 16)! + 1
        let newStr = NSString(format: "%0\(len)X" as NSString, num2) as String
        print("\nseq:",str)
        print("newSeq:",newStr)
        UserDefaultsClass.shared.setSequence(withSequence: newStr)
        let Seq = newStr
        if let value = UInt8(Seq, radix: 16) {
            Sequence4 = value
        }
    }
    
    //MARK: Alert Bluetooth Access
    func AlertNoBlueToothAccess(VC: UIViewController){
        let popup = PopupDialog(title: "\(Bundle.main.infoDictionary!["CFBundleName"] as! String) Would like to use Bluetooth", message: "Kindly Allow ZENO to access Bluetooth", image: UIImage())
        
        let buttonOne = CancelButton(title: "Settings") {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        popup.addButtons([buttonOne])
        VC.present(popup, animated: true, completion: nil)
    }
    
    //MARK: - getCurrentTime
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: Date())
    }
    
    //MARK: - getCurrent TimeStamp
    func getCurrentTimeStamp() -> String {
        let timestamp = NSDate().timeIntervalSince1970
        return (String(format: "%.0f", timestamp.rounded()))
    }
    
    //MARK: - getReadableDate
    func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    //MARK: - Date TO ReadableDate
    func convertDateToReadableDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    //MARK: - newProjectID
    func newProjectID(projectName: String)-> String  {
        let timestamp = NSDate().timeIntervalSince1970
        return "\(projectName)\("_")\(String(format: "%.0f", timestamp.rounded()))"
    }
    
    //MARK: - open scheme
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                    (success) in
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    //MARK: Global MoreinfoBtn Action
    func GlobalMenuBtn(VC: UIViewController, x: Int, y: Int){
        let configuration = FTConfiguration.shared
        configuration.backgoundTintColor = CELL_BG_COLOR
        configuration.borderWidth = 0
        configuration.menuSeparatorColor = CELL_BG_COLOR
        configuration.menuWidth = 190
        configuration.menuRowHeight = 50
        let ConfigurationMenuCell = FTCellConfiguration()
        ConfigurationMenuCell.textColor = .black
        ConfigurationMenuCell.textFont = UIFont(name: APP_REGULAR_FONT, size: 14)!
        ConfigurationMenuCell.textAlignment = .center
        let frame = CGRect(x: x, y: y , width: 300, height: 40)
        
        var  menuOptionNameArray = ["Calculator",
                                    "Calendar",
                                    "Configure Devices",
                                    "Conversion",
                                    "Device Settings",
                                    "Drawing Mode",
                                    "Report Analysis",
                                    "Report",
                                    "Stop Watch",
                                    "Surface Flatness"]
        
        if UserDefaultsClass.shared.getDeviceMode() == .MultiDeviceMode {
            menuOptionNameArray.remove(at: (9)) //Surface Flatness
        } else {
            if SelectedBle?.peri != nil{
                menuOptionNameArray.remove(at: (2)) //Configure Devices
            } else {
                menuOptionNameArray.remove(at: (2)) //Configure Devices
                menuOptionNameArray.remove(at: (8)) //Surface Flatness
            }
        }
        
        FTPopOverMenu.showFromSenderFrame(senderFrame: frame , with: menuOptionNameArray) { (selectedIndex) in
            
            var Choosed : SettingMenu = .Calculator
            if  UserDefaultsClass.shared.getDeviceMode() == .SingleDeviceMode {
                switch selectedIndex {
                case 0:
                    Choosed = .Calculator
                case 1:
                    Choosed = .Calendar
                case 2:
                    Choosed = .Conversion
                case 3:
                    Choosed = .DeviceSettings
                case 4:
                    Choosed = .DrawingMode
                case 5:
                    Choosed = .ReportAnalysis
                case 6:
                    Choosed = .Report
                case 7:
                    Choosed = .StopWatch
                case 8:
                    Choosed = .SurfaceFlatness
                default:
                    print("default")
                }
            } else {
                switch selectedIndex {
                case 0:
                    Choosed = .Calculator
                case 1:
                    Choosed = .Calendar
                case 2:
                    Choosed = .ConfigureDevices
                case 3:
                    Choosed = .Conversion
                case 4:
                    Choosed = .DeviceSettings
                case 5:
                    Choosed = .DrawingMode
                case 6:
                    Choosed = .ReportAnalysis
                case 7:
                    Choosed = .Report
                case 8:
                    Choosed = .StopWatch
                case 9:
                    Choosed = .SurfaceFlatness
                default:
                    print("default")
                }
            }
            self.MoveWithSettingMenu(Choosed: Choosed, FromVC: VC)
        } cancel: { }
    }
    
    //MARK: MoveWithSetting Choosed
    func MoveWithSettingMenu(Choosed: SettingMenu ,FromVC : UIViewController){
        
        switch Choosed {
        case .Calculator:
            print("Calculator")
            let vc = CalculatorVC()
            FromVC.navigationController?.pushViewController(vc, animated: true)
        case .Calendar:
            //                    let vc = CalenderVC()
            //                    VC.navigationController?.pushViewController(vc, animated: true)
            self.open(scheme: "calshow://")
            print("Calendar")
        case .ConfigureDevices:
            if SelectedBle?.peri != nil{
                let vc = MultiModeDeviceConfigVC()
                FromVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                FromVC.view.makeToast("No Device Connected", duration: 2, position: .bottom, title: nil, image: nil, style: ToastStyle(), completion: nil)
            }
            print("ConfigureDevices")
        case .Conversion:
//            let vc = DistanceConverterVC()
            let vc = ViewController()
            FromVC.navigationController?.pushViewController(vc, animated: true)
            print("Conversion")
        case .DeviceSettings:
            print("DeviceSettings")
        case .DrawingMode:
            let vc = DrawingModePopUpVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.ChooseDrawingMode = {(Mode: Int) in
                if Mode == 0{
                    let vc = ExpandDrawingVC()
                    FromVC.navigationController?.pushViewController(vc, animated: true)
                } else if Mode == 1{
                    let vc = DrawOnPicturePopUpVC()
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.ChooseDrawingMode = {(Mode: Int) in
                        if Mode == 0 {
                            let imagePicker = ImagePickerController()
                            imagePicker.settings.selection.max = 1
                            imagePicker.settings.selection.min = 1
                            FromVC.presentImagePicker(imagePicker, select: { (asset) in
                                // User selected an asset. Do something with it. Perhaps begin processing/upload?
                            }, deselect: { (asset) in
                                // User deselected an asset. Cancel whatever you did when asset was selected.
                            }, cancel: { (assets) in
                                // User canceled selection.
                            }, finish: { (assets) in
                                // User finished selection assets.
                                // Request the maximum size. If you only need a smaller size make sure to request that instead.
                                let manager = PHImageManager.default()
                                let option = PHImageRequestOptions()
                                var thumbnail = UIImage()
                                option.isSynchronous = true
                                manager.requestImage(for: assets[0], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                                    thumbnail = result!
                                    let vc = ExpandDrawingVC()
                                    vc.backgroundimage = thumbnail
                                    FromVC.navigationController?.pushViewController(vc, animated: true)
                                })
                            })
                        } else {
                            let vc = CameraVC()
                            vc.FromPage = "DrawingModePopUpVC"
                            vc.ExportImage = {(image : UIImage) in
                                let vc = ExpandDrawingVC()
                                vc.backgroundimage = image
                                vc.isFromPage = "CameraVC"
                                FromVC.navigationController?.pushViewController(vc, animated: true)
                            }
                            FromVC.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    FromVC.present(vc, animated: true, completion: nil)
                }
            }
            FromVC.present(vc, animated: true, completion: nil)
            print("DrawingMode")
        case .ReportAnalysis:
            let vc = ReportedProjectsVC()
            FromVC.navigationController?.pushViewController(vc, animated: true)
            print("ReportAnalysis")
        case .Report:
            let vc = ExistingProjectVC()
            FromVC.navigationController?.pushViewController(vc, animated: true)
            print("Report")
        case .StopWatch:
            let vc = StopwatchVC()
            FromVC.navigationController?.pushViewController(vc, animated: true)
            print("StopWatch")
        case .SurfaceFlatness:
            let projectid = "General"
            Entities.sharedInstance.addprojectsinfoToLocal(projectid: projectid, projectname: "General", Phonenumber: "", countrycode: "", customername : "", email: "", StreetNumber: "" , zipcodecity : "", country: "", createdtimestamp: Utility.shared.getCurrentTimeStamp())
            UserDefaultsClass.shared.setProjectId(projectid: projectid)
            let vc = SurfaceFlatMeasurementVC()
            vc.isTemporay = true
            vc.changesDone = { }
            FromVC.navigationController?.pushViewController(vc, animated: true)
            print("SurfaceFlatness")
        }
    }
    
    //MARK: utc To Local Time
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh:mm a"
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    //MARK: Sort Files from document directory
    func filesSortedList(atPath: URL) -> [(String,String,Date)]? {
        
        var fileNames = [(String,String, Date)]()
        let keys = [URLResourceKey.contentModificationDateKey]
        
        guard let fullPaths = try? FileManager.default.contentsOfDirectory(at: atPath, includingPropertiesForKeys:keys, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) else {
            return [("","",Date())]
        }
        
        let orderedFullPaths = fullPaths.sorted(by: { (url1: URL, url2: URL) -> Bool in
            do {
                let values1 = try url1.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                let values2 = try url2.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                
                if let date1 = values1.creationDate, let date2 = values2.creationDate {
                    //if let date1 = values1.contentModificationDate, let date2 = values2.contentModificationDate {
                    return date1.compare(date2) == ComparisonResult.orderedDescending
                }
            } catch _{
                
            }
            return true
        })
        
        for fileName in orderedFullPaths {
            do {
                let values = try fileName.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                if let date = values.creationDate {
                    if let date2 = values.contentModificationDate {
                        let time =  Utility.shared.utcToLocal(dateStr: date2.description)
                        let theFileName = fileName.lastPathComponent
                        fileNames.append((theFileName.description, time!.description, date2))
                    } else {
                        let time =  Utility.shared.utcToLocal(dateStr: date.description)
                        let theFileName = fileName.lastPathComponent
                        fileNames.append((theFileName.description, time!.description, date))
                    }
                }
            }
            catch _{
            }
        }
        return fileNames
    }
    
    func store(image: Data, forKey key: String) {
        
        if let filePath = filePath(forKey: key) {
            do  {
                try image.write(to: filePath, options: .atomic)
                
            } catch let err {
                print("Saving file resulted in error: ", err)
            }
        }
    }
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
}
