//
//  ShowDetailViewController.swift
//  Adopby
//
//  Created by Hatto on 29/4/2565 BE.
//

import UIKit
import Alamofire
import CometChatPro

class ShowDetailViewController: UIViewController {
    
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var viewOfDetail: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbAnnouceBy: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbNameAndAge: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbSex: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnChatWithPoster: UIButton!
    @IBOutlet weak var lbStatus: UILabel!
    
    var prepareData:PetPost!
    var prepareDataPetlost:Petlost!
    var keepCurrentUser:String = ""
    var keepCurrentUsernamePost:String = ""
    var url:URL!
    var user : User!
    let authKey = "5dcab8f18ef25a578d00667cdbede748b0c85d6d"
    
    @IBAction func btnDIsmiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupUI() {
        viewOfDetail.layer.cornerRadius = 10
        imgIcon.layer.masksToBounds = false
        imgIcon.clipsToBounds = true
        imgIcon.layer.cornerRadius = imgIcon.frame.width/2
        if prepareData != nil {
            //img
            imgPet.loadFrom(URLAddress: prepareData.imgURL)
            //type
            if dogType.contains(prepareData.petType) {
                imgIcon.image = UIImage.init(named: "dog.png")
            } else if catType.contains(prepareData.petType) {
                imgIcon.image = UIImage.init(named: "cat.png")
            }
            //fetchUser
            url = URL(string: "https://adoby.glitch.me/auth/\(prepareData.uid)")
            //
            lbAnnouceBy.text = prepareData.uid
            lbDate.text = String.getFormattedDate(dateFormString: prepareData.dateCreate)
            //name
            if prepareData.petName == "" {
                lbNameAndAge.text = "\(prepareData.petColor), \(prepareData.petAge)"
            } else {
                lbNameAndAge.text = "\(prepareData.petName), \(prepareData.petAge)"
            }
            //
            lbType.text = prepareData.petType
            lbSex.text = prepareData.petSex
            lbAddress.text = "ระแวกที่อยู่: \(prepareData.petAddress)"
            lbDescription.text = "คำอธิบายเพิ่มเติม: \(prepareData.petpostDescription)"
            //status
            if prepareData.status == "กำลังหาบ้าน" {
                lbStatus.backgroundColor = .init(rgb: 0x749D40)
                if dogType.contains(prepareData.petType) {
                    lbStatus.text = "🐶 กำลังหาบ้าน"
                } else if catType.contains(prepareData.petType) {
                    lbStatus.text = "🐱 กำลังหาบ้าน"
                }
            } else if prepareData.status == "มีบ้านแล้ว"{
                lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                lbStatus.text = "🏠 มีบ้านแล้ว"
            } else if prepareData.status == "จองแล้ว"{
                lbStatus.backgroundColor = .init(rgb: 0xF7D154)
                lbStatus.textColor = .init(rgb: 0x7E6514)
                lbStatus.text = "📌 จองแล้ว"
            } else {
                lbStatus.backgroundColor = .white
                lbStatus.text = ""
            }
        } else {
            //img
            imgPet.loadFrom(URLAddress: prepareDataPetlost.imgURL)
            //type
            if dogType.contains(prepareDataPetlost.petType) {
                imgIcon.image = UIImage.init(named: "dog.png")
            } else if catType.contains(prepareDataPetlost.petType) {
                imgIcon.image = UIImage.init(named: "cat.png")
            }
            //fethUser
            url = URL(string: "https://adoby.glitch.me/auth/\(prepareDataPetlost.uid)")
            //
            lbAnnouceBy.text = prepareDataPetlost.uid
            lbDate.text = prepareDataPetlost.lastSeen
            //name
            if prepareDataPetlost.petName == "" {
                lbNameAndAge.text = "\(prepareDataPetlost.petColor), \(prepareDataPetlost.petAge)"
            } else {
                lbNameAndAge.text = "\(prepareDataPetlost.petName), \(prepareDataPetlost.petAge)"
            }
            //
            lbType.text = prepareDataPetlost.petType
            lbSex.text = prepareDataPetlost.petSex
            lbAddress.text = "ระแวกที่อยู่: \(prepareDataPetlost.petAddress)"
            lbDescription.text = "คำอธิบายเพิ่มเติม: \(prepareDataPetlost.petlostDescription) \nรางวัล: \(prepareDataPetlost.price)"
            //status
            if prepareDataPetlost.status == "กำลังตามหา" {
                lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                if dogType.contains(prepareDataPetlost.petType) {
                    lbStatus.text = "🐶 กำลังตามหา"
                } else if catType.contains(prepareDataPetlost.petType) {
                    lbStatus.text = "🐱 กำลังตามหา"
                }
            } else if prepareDataPetlost.status == "เจอแล้ว"{
                lbStatus.backgroundColor = .init(rgb: 0x749D40)
                lbStatus.text = "🏠 เจอแล้ว"
            } else {
                lbStatus.backgroundColor = .white
                lbStatus.text = ""
            }
        }
        
        AF.request(
            url,
            method: .get
        ).responseDecodable(of: Users.self) { response in
            self.lbAnnouceBy.text = "ประกาศโดย: \(response.value?.username ?? "")"
        }

        //status
        lbStatus.layer.cornerRadius = 5
        lbStatus.layer.masksToBounds = true
        lbStatus.textColor = .white
        lbStatus.font = UIFont.init(name: "Prompt-Medium", size: 20)
        btnChatWithPoster.layer.masksToBounds = true
        btnChatWithPoster.layer.cornerRadius = 20
        btnChatWithPoster.startAnimatingPressActions()
    }
    
    func checkIfOwnUserPost() {
        if prepareData != nil {
            if keepCurrentUser == prepareData.uid {
                btnChatWithPoster.isHidden = true
            } else {
                btnChatWithPoster.isHidden = false
            }
        } else {
            if keepCurrentUser == prepareDataPetlost.uid {
                btnChatWithPoster.isHidden = true
            } else {
                btnChatWithPoster.isHidden = false
            }
        }
       
    }
    
    func fetchPostUser() {
        if prepareData != nil {
            url = URL(string: "https://adoby.glitch.me/auth/\(prepareData.uid)")
        } else {
            url = URL(string: "https://adoby.glitch.me/auth/\(prepareDataPetlost.uid)")
        }
        AF.request(url,method: .get)
            .responseDecodable(of: Users.self)
        { response in
            self.keepCurrentUsernamePost = response.value?.username ?? ""
        }
    }
    
    @IBAction func btnChatWithPoster(_ sender: Any) {
        if prepareData != nil {
            self.user = User(uid: prepareData.uid, name: keepCurrentUsernamePost)
        } else {
            self.user = User(uid: prepareDataPetlost.uid, name: keepCurrentUsernamePost)
        }

        CometChat.login(UID: keepCurrentUser, apiKey: authKey, onSuccess: { (user) in
            print("Login successfull: " + user.stringValue())
            self.openChat()
        }) { (error) in
            print("Login failed with error" + error.errorDescription)
        }
        
    }
    
    func openChat() {
        DispatchQueue.main.async {
            let messageList = CometChatMessageList()
            let navigationController = UINavigationController(rootViewController:messageList)
            messageList.set(conversationWith: self.user, type: .user)
            self.present(navigationController, animated:true, completion:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkIfOwnUserPost()
        DispatchQueue.main.async {
            self.fetchPostUser()
        }
        // Do any additional setup after loading the view.
    }
    

}
