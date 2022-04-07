//
//  HomeTableViewCell.swift
//  Adopby
//
//  Created by Hatto on 23/3/2565 BE.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lbPetName: UILabel!
    @IBOutlet weak var lbPetAge: UILabel!
    @IBOutlet weak var lbPetType: UILabel!
    @IBOutlet weak var lbPetAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
