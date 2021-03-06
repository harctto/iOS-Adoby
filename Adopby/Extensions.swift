//
//  Extensions.swift
//  Adopby
//
//  Created by Hatto on 17/3/2565 BE.
//
import UIKit
import DropDown
import Alamofire

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIViewController {
    func hideKB(){
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(dissmissmykb))
        view.addGestureRecognizer(tap)
    }
    @objc func dissmissmykb(){
        view.endEditing(true)
    }
    func cornerRadiusSetup( tf:[UITextField], btn:[UIButton], r:CGFloat ) {
        for t in tf {
            t.layer.cornerRadius = r
            t.isHidden = false
        }
        for b in btn {
            b.layer.cornerRadius = r
            b.isHidden = false
            b.startAnimatingPressActions()
        }
    }
    //DefaultDropdown
    func setupDefaultDropdown() {
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().textFont = UIFont(name: "Prompt-Regular", size: 16)!
        DropDown.appearance().backgroundColor = UIColor.init(rgb: 0xFBE6A2)
        DropDown.appearance().textColor = UIColor.init(rgb: 0x7E6514)
        DropDown.appearance().selectedTextColor = UIColor.init(rgb: 0xFBE6A2)
        DropDown.appearance().selectionBackgroundColor = UIColor.init(rgb: 0x7E6514)
    }
    //adjust
    func adjustDropdown( dd: DropDown, view: UIButton ) {
        dd.anchorView = view
        dd.direction = .bottom
        dd.dismissMode = .automatic
        dd.selectionAction = { index, title in
            view.setTitle(title, for: .normal)
        }
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}

public func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContext(newSize)
    image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
            button.transform = transform
        }, completion: nil)
    }
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    
    static func uniqueFilename(withPrefix prefix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if prefix != nil {
            return "\(prefix!)-\(uniqueString)"
        }
        
        return uniqueString
    }
    
    subscript(_ range: NSRange) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
    
    static func getFormattedDate(dateFormString: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateformat.date(from: dateFormString)!
        
        dateformat.dateFormat = "d MMM, yyy (h:mm a)"
        let dateString = dateformat.string(from: date)
        return dateString
    }
    
}

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController{
    func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "??????????????????????????????????????????...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        ProgressDialog.alert.view.addSubview(loadingIndicator)
        present(ProgressDialog.alert, animated: true, completion: nil)
    }
    
    func LoadingStop(){
        ProgressDialog.alert.dismiss(animated: true, completion: nil)
    }
}
