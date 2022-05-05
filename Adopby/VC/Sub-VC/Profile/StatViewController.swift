//
//  StatViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Charts
import Alamofire

class StatViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: BarChartView!
    var chartType:String = ""
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if chartType == "post" {
            AF.request(
                "https://adoby.glitch.me/petposts",
                method: .get
            ).responseDecodable(of: [PetPost].self) { response in
                switch (response.result) {
                case .success:
                    var entries = [BarChartDataEntry]()
                    var entries2 = [BarChartDataEntry]()
                    var entries3 = [BarChartDataEntry]()
                    var x:Int = 0
                    var y:Int = 0
                    var z:Int = 0
                    for i:PetPost in response.value! {
                        switch i.status {
                        case "กำลังหาบ้าน":
                            x += 1
                        case "จองแล้ว":
                            y += 1
                        case "มีบ้านแล้ว":
                            z += 1
                        default:
                            break
                        }
                    }
                    entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
                    entries2.append(BarChartDataEntry(x: Double(y), y: Double(y)))
                    entries3.append(BarChartDataEntry(x: Double(z), y: Double(z)))
                    let set = BarChartDataSet(entries: entries,label: "กำลังหาบ้าน")
                    set.colors = [.init(rgb: 0x749D40)]
                    let set2 = BarChartDataSet(entries: entries2,label: "จองแล้ว")
                    set2.colors = [.init(rgb: 0xCB4224)]
                    let set3 = BarChartDataSet(entries: entries3, label: "มีบ้านแล้ว")
                    set3.colors = [.init(rgb: 0xF7D154)]
                    let data = BarChartData(dataSets: [set,set2,set3])
                    self.chartView.data = data
                case .failure:
                    break
                }
            }
        } else {
            AF.request(
                "https://adoby.glitch.me/petlosts",
                method: .get
            ).responseDecodable(of: [Petlost].self) { response in
                switch (response.result) {
                case .success:
                    var entries = [BarChartDataEntry]()
                    var entries2 = [BarChartDataEntry]()
                    var x:Int = 0
                    var y:Int = 0
                    for i:Petlost in response.value! {
                        switch i.status {
                        case "กำลังตามหา":
                            x += 1
                        case "เจอแล้ว":
                            y += 1
                        default:
                            break
                        }
                    }
                    entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
                    entries2.append(BarChartDataEntry(x: Double(y), y: Double(y)))
                    let set = BarChartDataSet(entries: entries,label: "กำลังหาบ้าน")
                    set.colors = [.init(rgb: 0x749D40)]
                    let set2 = BarChartDataSet(entries: entries2,label: "จองแล้ว")
                    set2.colors = [.init(rgb: 0xCB4224)]
                    let data = BarChartData(dataSets: [set,set2])
                    self.chartView.data = data
                case .failure:
                    break
                }
            }
        }
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
