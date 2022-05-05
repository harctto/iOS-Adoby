//
//  ProfileViewController.swift
//  Adopby
//
//  Created by Hatto on 4/5/2565 BE.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnEditPost: UIButton!
    @IBOutlet weak var btnEditLost: UIButton!
    @IBOutlet weak var btnStatFindHome: UIButton!
    @IBOutlet weak var btnStatMissing: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    //variable
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    var currentUsername:Users!
    
    @IBOutlet weak var viewUnderline: UIView!
    
    func iconDisplayed(ic: [UIImageView]) {
        for i in ic {
            i.isHidden = false
        }
    }
    
    func setupUI() {
        cornerRadiusSetup(
            tf: [],
            btn: [btnEditProfile,btnEditPost,btnEditLost,btnStatMissing,btnStatFindHome,btnLogout],
            r: 20
        )
        let btnFont:UIFont = .init(name: "Prompt-Medium", size: 28)!
        lbName.isHidden = false
        btnEditProfile.titleLabel?.font = btnFont
        btnEditPost.titleLabel?.font = btnFont
        btnStatMissing.titleLabel?.font = btnFont
        btnStatFindHome.titleLabel?.font = btnFont
        btnLogout.titleLabel?.font = btnFont
        viewUnderline.isHidden = false
        viewUnderline.layer.cornerRadius = 5
        viewTop.isHidden = false
        iconDisplayed(ic: [icon,icon1,icon2,icon3,icon4])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupUI()
            self.LoadingStop()
        }
        let modalController = EditProfileViewController()
        modalController.isDismissed = { [weak self] in
           self?.viewWillAppear(true)
        }
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let valueTabbar = tabBarController as! BaseTabbar
        let url = "https://adoby.glitch.me/auth/\(valueTabbar.userData[0])"
        DispatchQueue.main.async {
            AF.request(
                url,
                method: .get
            ).responseDecodable(of: Users.self) { response in
                self.currentUsername = response.value
                self.lbName.text = "คุณ \(self.currentUsername.firstname ?? "")"
            }
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        self.dismiss(animated: true)
        self.LoadingStop()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            let sender = segue.destination as! EditProfileViewController
            sender.keepUser = currentUsername
        }
        if segue.identifier == "sentPost" {
            let sender = segue.destination as! StatViewController
            sender.chartType = "post"
        }
        if segue.identifier == "sentLost" {
            let sender = segue.destination as! StatViewController
            sender.chartType = "lost"
        }
        if segue.identifier == "sendPetPost" {
            let navigationContoller = segue.destination as! UINavigationController
            let receiverViewController = navigationContoller.topViewController as! PetPostTableViewController
            receiverViewController.currentUsername = currentUsername
        }
        if segue.identifier == "sendPetLost" {
            let navigationContoller = segue.destination as! UINavigationController
            let receiverViewController = navigationContoller.topViewController as! PetLostTableViewController
            receiverViewController.currentUsername = currentUsername
        }
    }
    

}
