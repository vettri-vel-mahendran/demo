//
//  Extension.swift
//  DemoWorkProject
//
//  Created by apple on 19/11/21.
//

import Foundation
import UIKit

//MARK: Filter Duplicate Elements in Array
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Array where Element: Equatable {
    func uniqueElements() -> [Element] {
        var out = [Element]()
        
        for element in self {
            if !out.contains(element) {
                out.append(element)
            }
        }
        
        return out
    }
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}


//MARK: - extension label
extension UILabel{
    
    //MARK: configure label
    public func config(color:UIColor,size:CGFloat, align:NSTextAlignment, text:String, font: String ){
        self.textColor = color
        self.textAlignment = align
        self.text = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String
        self.font = UIFont.init(name: font, size: size)
    }
    //MARK: Translate Text
    public func TranslatedTextOf(text:String){
        self.text = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String
    }
}

//MARK: - extension View
extension UIView{
    
    //MARK: convert View to image
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    //MARK: shadow effect
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        self.layer.shadowRadius = 3; // 1
        self.layer.shadowOpacity = 0.2;
    }
    
    //MARK: apply gradient effect
    func applyGradient()  {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(named: "PRIMARY_COLOR")!.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0, 0.25, 1, 0.25, 0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
    }
    
    //MARK: shadow effect
    func AllsideelevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
    }
    
    //MARK: Specific Corner Radius
    func SpecificCornerRadius(radius: Int){
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    //MARK: Rounded Corner Radius
    func RoundedCornerRadius(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    //MARK: View Tap Gesture
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

//MARK: - extension ImageView

extension UIImageView {
    
    //MARK: image Tap Gesture
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapImgGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTap(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapImgGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

//MARK: - extension Button

extension UIButton {
    
    //MARK: configure Button
    public func config(Bgcolor:UIColor, size:CGFloat, text:String, textcolor: UIColor, font: String ){
        self.titleLabel?.font = UIFont.init(name: font, size: size)
        self.setTitle(UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String, for: .normal)
        self.backgroundColor = Bgcolor
        self.setTitleColor(textcolor, for: .normal)
    }
    
    public func TranslatedTextOf(text:String){
        self.setTitle(UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String, for: .normal)
    }
}

//MARK: - extension TextField

extension UITextField {
    
    //MARK: configure TextField
    public func config(color:UIColor,size:CGFloat, placeholdertext:String, font: String ){
        self.placeholder = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: placeholdertext) as? String
        self.font = UIFont.init(name: font, size: size)
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = color
    }
    
    public func TranslatedTextOf(placeholdertext:String){
        self.placeholder = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: placeholdertext) as? String
    }
    
}

//MARK: - extension TextView

extension UITextView {
    
    //MARK: configure TextView
    public func config(color:UIColor,size:CGFloat, text:String, font: String ){
        self.text = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String
        self.font = UIFont.init(name: font, size: size)
        self.textColor = color
    }
    
    public func TranslatedTextOf(text:String){
        self.text = UserDefaultsClass.shared.getLanguageDict()?.value(forKey: text) as? String
    }
}

//MARK: - extension Device
extension UIDevice {
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

//MARK: - extension Application
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

//MARK: Automatic TV Height
final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

//MARK: - extension String
extension String{
    //check mail is valid
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    //convert hexStringtoAscii
    func hexStringtoAscii() -> String {
        
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = self as NSString
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }
    
}

//MARK: - extension Data
extension Data {
    //convert DatatoHex
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

