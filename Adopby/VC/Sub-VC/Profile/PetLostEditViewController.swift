//
//  PetLostEditViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import DropDown
import Alamofire
import FirebaseStorage

class PetLostEditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var keepPostData:Petlost!
    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var btnAgeY: UIButton!
    @IBOutlet weak var btnAgeM: UIButton!
    @IBOutlet weak var btnSex: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnPetType: UIButton!
    @IBOutlet weak var tfDatePicker: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var btnUploadPicture: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var ddBtnStatus: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    //variable
    var keepUserUID:String = ""
    let ddAgeY = DropDown()
    let ddAgeM = DropDown()
    let ddSex = DropDown()
    let ddType = DropDown()
    let ddAddress = DropDown()
    let ddStatus = DropDown()
    var isDismissed: (() -> Void)?
    var storage = Storage.storage().reference()
    var imageUrl:String = ""
    var imageName:String = ""
    var keepStatus:String = ""
    
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = .init(rgb: 0xFEF8E7)
        cornerRadiusSetup(
            tf: [tfPetName,tfPetColor,tfPrice,tfDatePicker,tfDescription],
            btn: [btnAgeY,btnAgeM,btnSex,btnAddress,btnPetType,ddBtnStatus,btnUploadPicture,btnSubmit,btnCancel],
            r: 20
        )
        btnCancel.startAnimatingPressActions()
        btnUploadPicture.startAnimatingPressActions()
        btnSubmit.startAnimatingPressActions()
        btnUploadPicture.startAnimatingPressActions()
        btnDelete.startAnimatingPressActions()
        btnAgeY.startAnimatingPressActions()
        btnAgeM.startAnimatingPressActions()

        imgPreview.layer.masksToBounds = true
        imgPreview.layer.cornerRadius = 20
        //setDefault
        tfPetName.text = keepPostData.petName
        tfPetColor.text = keepPostData.petColor
        btnSex.setTitle(keepPostData.petSex, for: .normal)
        btnAddress.setTitle(keepPostData.petAddress, for: .normal)
        if dogType.contains(keepPostData.petType) {
            ddType.dataSource = dogType
        } else {
            ddType.dataSource = catType
        }
        btnPetType.setTitle(keepPostData.petType, for: .normal)
        tfDescription.text = keepPostData.petlostDescription
        imgPreview.loadFrom(URLAddress: keepPostData.imgURL)
        imageUrl = keepPostData.imgURL
        tfPrice.text = keepPostData.price
        keepStatus = keepPostData.status
        onChangeStatus()
    }
    
    func onChangeStatus() {
        if keepStatus == "??????????????????????????????" {
            ddBtnStatus.setTitle("???? ??????????????????????????????", for: .normal)
            ddBtnStatus.backgroundColor = .init(rgb: 0xF7D154)
            ddBtnStatus.setTitleColor(.white, for: .normal)
        } else if keepStatus == "?????????????????????"{
            ddBtnStatus.backgroundColor = .init(rgb: 0xCB4224)
            ddBtnStatus.setTitleColor(.white, for: .normal)
            ddBtnStatus.setTitle("???? ?????????????????????", for: .normal)
        } else {
            ddBtnStatus.backgroundColor = .white
            ddBtnStatus.setTitle("", for: .normal)
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
        let doneButton = UIBarButtonItem.init(title: "??????????????????", style: .done, target: self, action: #selector(self.datePickerDone))
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
        let url = "https://adoby.glitch.me/petlosts/edit/\(keepPostData.petID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text ?? "")",
            "pet_type":"\(btnPetType.currentTitle ?? "")",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(btnSex.currentTitle ?? "")",
            "pet_age":"\(btnAgeY.currentTitle ?? "") ?????? \(btnAgeM.currentTitle ?? "") ???",
            "pet_address":"\(btnAddress.currentTitle ?? "")",
            "description":"\(tfDescription.text!)",
            "img_url":"\(self.imageUrl)",
            "last_seen":"\(self.tfDatePicker.text ?? "")",
            "price":"\(self.tfPrice.text ?? "")",
            "status":"\(keepStatus)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        if (
            self.btnPetType.currentTitle ?? "" != "" &&
            self.btnSex.currentTitle ?? "" != "" &&
            self.btnAgeY.currentTitle ?? "" != "???????????? (??????)" &&
            self.btnAgeM.currentTitle ?? "" != "???????????? (???????????????)" &&
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
                    title: "?????????????????????????????????????????????",
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
                title: "???????????????????????????????????????????????????",
                message: "???????????????????????????????????????????????????????????????????????????",
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
    @IBAction func handleTapDdStatus(_ sender: Any) {
        ddStatus.show()
    }
    
    func setupDropdown() {
        setupDefaultDropdown()
        ddAgeY.dataSource = ageY
        ddAgeM.dataSource = ageM
        ddSex.dataSource = sex
        ddAddress.dataSource = addressBangkok
        ddStatus.dataSource = ["??????????????????????????????","?????????????????????"]
        //
        adjustDropdown(dd: ddStatus, view: ddBtnStatus)
        adjustDropdown(dd: ddAgeY, view: btnAgeY)
        adjustDropdown(dd: ddAgeM, view: btnAgeM)
        adjustDropdown(dd: ddSex, view: btnSex)
        adjustDropdown(dd: ddAddress, view: btnAddress)
        adjustDropdown(dd: ddType, view: btnPetType)
        ddStatus.selectionAction = { [unowned self] (index: Int, item: String) in
            keepStatus = item
            onChangeStatus()
        }
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
