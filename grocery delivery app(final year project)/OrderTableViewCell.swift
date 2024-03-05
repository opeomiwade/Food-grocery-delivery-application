//
//  OrderTableViewCell.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 20/02/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var foodItem: UILabel!
    
    @IBOutlet weak var restuarantLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
