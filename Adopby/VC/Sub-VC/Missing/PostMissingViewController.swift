//
//  PostMissingViewController.swift
//  Adopby
//
//  Created by Hatto on 4/5/2565 BE.
//

import UIKit
import DropDown
import Alamofire
import FirebaseStorage

class PostMissingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var btnAgeY: UIButton!
    @IBOutlet weak var btnAgeM: UIButton!
    @IBOutlet weak var btnSex: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var sgPetType: UISegmentedControl!
    @IBOutlet weak var btnPetType: UIButton!
    @IBOutlet weak var tfDatePicker: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var btnUploadPicture: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    //variable
    var keepUserUID:String = ""
    let ddAgeY = DropDown()
    let ddAgeM = DropDown()
    let ddSex = DropDown()
    let ddType = DropDown()
    let ddAddress = DropDown()
    var isDismissed: (() -> Void)?
    var storage = Storage.storage().reference()
    var imageUrl:String = ""
    var imageName:String = ""
    
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = .init(rgb: 0xFEF8E7)
        cornerRadiusSetup(
            tf: [tfPetName,tfPetColor,tfPrice,tfDatePicker,tfDescription],
            btn: [btnAgeY,btnAgeM,btnSex,btnAddress,btnPetType,btnUploadPicture,btnSubmit,btnCancel],
            r: 20
        )
        btnCancel.startAnimatingPressActions()
        btnUploadPicture.startAnimatingPressActions()
        sgPetType.frame.size.height = 85
        sgPetType.contentMode = .scaleAspectFit
        imgPreview.layer.masksToBounds = true
        imgPreview.layer.cornerRadius = 20
        btnPetType.backgroundColor = .gray
        btnPetType.setTitleColor(.init(rgb: 0xFBE6A2), for: .normal)
        let dogImage = image(
            with: (UIImage(named: "dog-1.png")),
            scaledTo: CGSize(width: 40, height: 40)
        )
        let catImage = image(
            with: UIImage(named: "cat-1.png"),
            scaledTo: CGSize(width: 40, height: 40)
        )
        sgPetType.setImage(dogImage, forSegmentAt: 0)
        sgPetType.setImage(catImage, forSegmentAt: 1)
    }
    
    @IBAction func setupDogCat(_ sender: Any) {
        switch sgPetType.selectedSegmentIndex {
        case 0:
            ddType.dataSource = dogType
            btnPetType.isUserInteractionEnabled = true
            btnPetType.backgroundColor = .init(rgb: 0xFBE6A2)
            btnPetType.setTitleColor(.init(rgb: 0xA78721), for: .normal)
            btnPetType.setTitle("พันธุ์", for: .normal)
        case 1:
            ddType.dataSource = catType
            btnPetType.isUserInteractionEnabled = true
            btnPetType.backgroundColor = .init(rgb: 0xFBE6A2)
            btnPetType.setTitleColor(.init(rgb: 0xA78721), for: .normal)
            btnPetType.setTitle("พันธุ์", for: .normal)
        default:
            btnPetType.isUserInteractionEnabled = false
            btnPetType.setTitle("กรุณาเลือกสุนัข หรือ แมว", for: .normal)
        }
    }
    
    // MARK: - datePicker
    func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyy"
        if #available(iOS 15, *) {
            tfDatePicker.text = dateFormatter.string(from: Date.now)
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        tfDatePicker.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "ยืนยัน", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 40))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        tfDatePicker.inputAccessoryView = toolBar
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyy"
        tfDatePicker.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerDone() {
          tfDatePicker.resignFirstResponder()
    }
    
    
    
    // MARK: - submitPost
    @IBAction func btnSubmit(_ sender: Any) {
        let url = "https://adoby.glitch.me/petlosts/\(keepUserUID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text ?? "")",
            "pet_type":"\(btnPetType.currentTitle ?? "")",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(btnSex.currentTitle ?? "")",
            "pet_age":"\(btnAgeY.currentTitle ?? "") ปี \(btnAgeM.currentTitle ?? "") ด",
            "pet_address":"\(btnAddress.currentTitle ?? "")",
            "description":"\(tfDescription.text!)",
            "img_url":"\(self.imageUrl)",
            "last_seen":"\(self.tfDatePicker.text ?? "")",
            "price":"\(self.tfPrice.text ?? "")"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        if (
            self.btnPetType.currentTitle ?? "" != "" &&
            self.btnSex.currentTitle ?? "" != "" &&
            self.btnAgeY.currentTitle ?? "" != "อายุ (ปี)" &&
            self.btnAgeM.currentTitle ?? "" != "อายุ (เดือน)" &&
            self.btnAddress.currentTitle ?? "" != "" &&
            self.tfDescription.text != "" &&
            self.tfPetColor.text != "" &&
            self.tfDatePicker.text != "" &&
            self.imageUrl != ""
        ) {
            AF.request(
                url,
                method: .post,
                parameters: params,
                encoder: encoder,
                headers: _headers
            ).responseDecodable(of: [Petlost].self) { response in
                let alert = UIAlertController(
                    title: "ลงทะเบียนสำเร็จ",
                    message: "",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    self.dismiss(animated: true, completion: {
                        self.isDismissed?()
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(
                title: "มีบางอย่างผิดพลาด",
                message: "กรุณากรอกข้อมูลให้ครบถ้วน",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isDismissed?()
        })
        storage.child("petlosts/\(imageName).png").delete()
    }
    
    // MARK: - imageFunction
    @IBAction func btnUploadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        if imageUrl != "" {
            btnUploadPicture.isEnabled = false
            btnUploadPicture.backgroundColor = .gray
        } else {
            btnUploadPicture.isEnabled = true
            btnUploadPicture.backgroundColor = .init(rgb: 0xA78721)
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        storage.child("petlosts/\(imageName).png").delete()
        self.LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imgPreview.image = UIImage.init(named: "App_Icon_Useable")
            self.imageUrl = ""
            self.btnUploadPicture.isEnabled = true
            self.btnUploadPicture.backgroundColor = .init(rgb: 0xA78721)
            self.LoadingStop()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        imageName = String.uniqueFilename()
        
        storage.child("petlosts/\(imageName).png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("petlosts/\(self.imageName).png").downloadURL(completion: { url, error in
                guard let url = url,error == nil else {
                    return
                }
                let urlString = url.absoluteString
                self.LoadingStart()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.LoadingStop()
                    self.btnUploadPicture.isEnabled = false
                    self.btnUploadPicture.backgroundColor = .gray
                    self.imgPreview.loadFrom(URLAddress: urlString)
                    self.imageUrl = urlString
                }
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - dropdownSetup
    @IBAction func handleTapDdAgeY(_ sender: Any) {
        ddAgeY.show()
    }
    @IBAction func handleTapDdAgeM(_ sender: Any) {
        ddAgeM.show()
    }
    @IBAction func handleTapDdSex(_ sender: Any) {
        ddSex.show()
    }
    @IBAction func handleTapDdAddress(_ sender: Any) {
        ddAddress.show()
    }
    @IBAction func handleTapDdType(_ sender: Any) {
        ddType.show()
    }
    
    func setupDropdown() {
        setupDefaultDropdown()
        ddAgeY.dataSource = ageY
        ddAgeM.dataSource = ageM
        ddSex.dataSource = sex
        ddAddress.dataSource = addressBangkok
        
        adjustDropdown(dd: ddAgeY, view: btnAgeY)
        adjustDropdown(dd: ddAgeM, view: btnAgeM)
        adjustDropdown(dd: ddSex, view: btnSex)
        adjustDropdown(dd: ddAddress, view: btnAddress)
        adjustDropdown(dd: ddType, view: btnPetType)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdown()
        showDatePicker()
        hideKB()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
