//
//  HomeViewController.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import UIKit
import Alamofire
import AnimatableReload
import CometChatPro

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variable
    var currentUsername:Users!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var btnModal: UIButton!
    
    let refreshControl = UIRefreshControl()
    var countforrow:Int = 0
    var keepData:[PetPost] = []
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.registerTableViewCells()
        lbUsername.text = currentUsername.firstname ?? ""
        self.tableview.rowHeight = 177
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .clear
        //reload table when pull
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x7E6514)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(rgb: 0x7E6514)
        tableview.addSubview(refreshControl)
        btnModal.startAnimatingPressActions()
        view.isHidden = false
    }
    // MARK: - TableFunction
    func fetchDataForCellRow() {
        guard let url = URL(string: "https://adoby.glitch.me/petposts") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [PetPost].self)
        { response in
            self.countforrow = response.value!.count as Int
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countforrow
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "dataSent", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cell.bgView.backgroundColor = .white
            }
            else {
                cell.bgView.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
            }
            //fetch data
            let url = "https://adoby.glitch.me/petposts"
            AF.request(url,method: .get)
                .responseDecodable(of: [PetPost].self)
            { response in
                self.keepData = response.value!
                if self.keepData.indices.contains(0) {
                    if self.keepData[safe: indexPath.row]?.petName == "" {
                        if self.keepData[safe: indexPath.row]?.petColor.contains("สี") == true {
                            cell.lbPetName.text = self.keepData[safe: indexPath.row]?.petColor
                        } else {
                            cell.lbPetName.text = "สี\(self.keepData[safe: indexPath.row]?.petColor ?? "")"
                        }
                    } else {
                        cell.lbPetName.text = "ชื่อ: \(self.keepData[safe: indexPath.row]?.petName ?? "")"
                    }
                    if self.keepData[safe: indexPath.row]?.petType == "------ไม่ทราบ------" {
                        cell.lbPetType.text = "พันธุ์: ไม่ทราบ"
                    } else {
                        cell.lbPetType.text = "พันธุ์: \(self.keepData[safe: indexPath.row]?.petType ?? "")"
                    }
                    let colorCellSelected = UIView()
                    colorCellSelected.backgroundColor  = UIColor.red.withAlphaComponent(0)
                    cell.selectedBackgroundView = colorCellSelected
                    cell.lbPetAge.text = "\(self.keepData[safe: indexPath.row]?.petAge ?? "")"
                    cell.lbPetDescription.text = self.keepData[safe: indexPath.row]?.petpostDescription
                    cell.lbPetAddress.text = "เขต: \(self.keepData[safe: indexPath.row]?.petAddress ?? "")"
                    cell.imgPet.loadFrom(URLAddress: self.keepData[safe: indexPath.row]?.imgURL ?? "")
                    if self.keepData[safe: indexPath.row]?.status == "กำลังหาบ้าน" {
                        cell.lbStatus.backgroundColor = .init(rgb: 0x749D40)
                        if dogType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                            cell.lbStatus.text = "🐶 กำลังหาบ้าน"
                        } else if catType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                            cell.lbStatus.text = "🐱 กำลังหาบ้าน"
                        }
                    } else if self.keepData[safe: indexPath.row]?.status == "มีบ้านแล้ว"{
                        cell.lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                        cell.lbStatus.text = "🏠 มีบ้านแล้ว"
                    } else if self.keepData[safe: indexPath.row]?.status == "จองแล้ว"{
                        cell.lbStatus.backgroundColor = .init(rgb: 0xF7D154)
                        cell.lbStatus.textColor = .init(rgb: 0x7E6514)
                        cell.lbStatus.text = "📌 จองแล้ว"
                    } else {
                        cell.lbStatus.backgroundColor = .white
                        cell.lbStatus.text = ""
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "HomeTableViewCell",
                                  bundle: nil)
        self.tableview.register(textFieldCell,
                                forCellReuseIdentifier: "HomeTableViewCell")
    }
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        //setup Function
        DispatchQueue.main.async {
            self.fetchDataForCellRow()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupUI()
            //
            let currentUser = User(uid: self.currentUsername.uid, name: self.currentUsername.username)
            CometChat.updateCurrentUserDetails(user: currentUser, onSuccess: { user in
                print("Updated user object",user)
            }, onError: { error in
                print("Update user failed with error: \(String(describing: error?.errorDescription))")
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableview.reloadData()
            AnimatableReload.reload(tableView: self.tableview, animationDirection: "up")
        }
        //
        let modalController = PostViewController()
        modalController.isDismissed = { [weak self] in
           self?.viewWillAppear(true)
        }
        
        super.viewDidLoad()
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //
        let valueTabbar = tabBarController as! BaseTabbar
        let url = "https://adoby.glitch.me/auth/\(valueTabbar.userData[0])"
        DispatchQueue.main.async {
            AF.request(
                url,
                method: .get
            ).responseDecodable(of: Users.self) { response in
                self.currentUsername = response.value
            }
            self.fetchDataForCellRow()
        }
        //
        self.LoadingStart()
        tableview.reloadData()
        countforrow = 0
        refreshControl.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.LoadingStop()
            self.tableview.reloadData()
            AnimatableReload.reload(tableView: self.tableview, animationDirection: "up")
            self.refreshControl.endRefreshing()
        }
    }
    // MARK: - refresh
    @objc func refresh(_ sender: AnyObject) {
        tableview.reloadData()
        fetchDataForCellRow()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            let sender = segue.destination as! PostViewController
            sender.keepUserUID = currentUsername.uid ?? ""
        }
        if segue.identifier == "dataSent" {
            let sender = segue.destination as! ShowDetailViewController
            sender.prepareData = self.keepData[safe: tableview.indexPathForSelectedRow!.row]
            sender.keepCurrentUser = currentUsername.uid ?? ""
            sender.keepCurrentUsernamePost = currentUsername.username ?? ""

        }
    }
    
}
