//
//  HomeViewController.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUsername:[String] = []
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lbUsername: UILabel!
    let refreshControl = UIRefreshControl()
    var countforrow:Int = 0
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.registerTableViewCells()
        lbUsername.text = currentUsername[1]
        self.tableview.rowHeight = 177
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .clear
        //reload table when pull
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x7E6514)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(rgb: 0x7E6514)
        tableview.addSubview(refreshControl)
    }
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
                cell.imgPet.layer.cornerRadius = 20
                cell.imgPet.contentMode = .scaleAspectFit
            }
            else {
                cell.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
                cell.imgPet.layer.cornerRadius = 20
                cell.imgPet.contentMode = .scaleAspectFit
            }
            cell.lbPetName.textColor = .black
            cell.lbPetType.textColor = .black
            cell.lbPetAddress.textColor = .black
            cell.lbPetAge.textColor = .black
            //fetch data
            let url = "https://adoby.glitch.me/petposts"
            AF.request(url,method: .get)
                .responseDecodable(of: [PetPost].self)
            { response in
                let keepData:[PetPost] = response.value!
                if keepData.indices.contains(0) {
                    cell.lbPetName.text = keepData[safe: indexPath.row]?.petName
                    cell.lbPetType.text = keepData[safe: indexPath.row]?.petType
                    cell.lbPetAge.text = keepData[safe: indexPath.row]?.petAge
                    cell.lbPetAddress.text = keepData[safe: indexPath.row]?.petpostDescription
                    cell.imgPet.loadFrom(URLAddress: keepData[safe: indexPath.row]?.imgURL ?? "")
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
    
    override func viewDidLoad() {
        let valueTabbar = tabBarController as! BaseTabbar
        currentUsername = valueTabbar.userData
        //setup Function
        setupUI()
        fetchDataForCellRow()
        //reload await
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableview.reloadData()
        }
        let modalController = PostViewController()
        modalController.isDismissed = { [weak self] in
           self?.viewWillAppear(true)
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
        fetchDataForCellRow()
        countforrow = 0
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableview.reloadData()
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
        if segue.identifier == "postSegue" {
            let sender = segue.destination as! PostViewController
            sender.keepUserUID = currentUsername[0]
        }
    }
    
}
