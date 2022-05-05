//
//  MissingViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import Alamofire
import AnimatableReload

class MissingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    let refreshControl = UIRefreshControl()
    var countforrow:Int = 0
    var currentUsername:Users!
    var keepData:[Petlost] = []
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        self.tableview.dataSource = self
        self.tableview.delegate = self
        registerTableViewCells()
        self.tableview.rowHeight = 177
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .clear
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x7E6514)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(rgb: 0x7E6514)
        tableview.addSubview(refreshControl)
    }
    
    func fetchDataForCellRow() {
        guard let url = URL(string: "https://adoby.glitch.me/petlosts") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [Petlost].self)
        { response in
            self.countforrow = response.value!.count as Int
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MissingTableViewCell", bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: "MissingTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countforrow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "dataSentFromMissing", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MissingTableViewCell") as? MissingTableViewCell {
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cell.bgCell.backgroundColor = .white
            }
            else {
                cell.bgCell.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
            }
            //fetch data
            let url = "https://adoby.glitch.me/petlosts"
            AF.request(url,method: .get)
                .responseDecodable(of: [Petlost].self)
            { response in
                self.keepData = response.value!
                if self.keepData.indices.contains(0) {
                    cell.lbPetName.text = self.keepData[safe: indexPath.row]?.petName
                    cell.lbPetType.text = self.keepData[safe: indexPath.row]?.petType
                    cell.lbPetAge.text = "\(self.keepData[safe: indexPath.row]?.petAge ?? "") ขวบ"
                    cell.lbPetDescription.text = self.keepData[safe: indexPath.row]?.petlostDescription
                    cell.lbLastSeen.text = self.keepData[safe: indexPath.row]?.lastSeen
                    cell.lbPrice.text = "รางวัล : \(self.keepData[safe: indexPath.row]?.price ?? "") บาท"
                    cell.imgPet.loadFrom(URLAddress: self.keepData[safe: indexPath.row]?.imgURL ?? "")
                    //
                    let colorCellSelected = UIView()
                    colorCellSelected.backgroundColor  = UIColor.red.withAlphaComponent(0)
                    cell.selectedBackgroundView = colorCellSelected
                    //
                    if self.keepData[safe: indexPath.row]?.status == "กำลังตามหา" {
                        cell.lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                        cell.lbStatus.text = "😿 กำลังตามหา"
                    } else if self.keepData[safe: indexPath.row]?.status == "เจอแล้ว"{
                        cell.lbStatus.backgroundColor = .init(rgb: 0x749D40)
                        cell.lbStatus.text = "🏠 เจอแล้ว"
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
    
    override func viewDidLoad() {
        //setup Function
        DispatchQueue.main.async {
            self.fetchDataForCellRow()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupUI()
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
    
    @objc func refresh(_ sender: AnyObject) {
        tableview.reloadData()
        fetchDataForCellRow()
        refreshControl.endRefreshing()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "dataSentPostMissingPet" {
             let sender = segue.destination as! PostMissingViewController
             sender.keepUserUID = currentUsername.uid
         }
         if segue.identifier == "dataSentFromMissing" {
             let sender = segue.destination as! ShowDetailViewController
             sender.prepareDataPetlost = self.keepData[safe: tableview.indexPathForSelectedRow!.row]
             sender.keepCurrentUser = currentUsername.uid
             sender.keepCurrentUsernamePost = currentUsername.username
         }
         
     }
     
    
}
