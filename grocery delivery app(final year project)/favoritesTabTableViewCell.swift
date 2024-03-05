//
//  favoritesTabTableViewCell.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 06/02/2023.
//

import UIKit

class favoritesTabTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
}
