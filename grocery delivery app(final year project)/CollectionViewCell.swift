//
//  CollectionViewCell.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 08/01/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func layoutSubviews() {
        //round corners of cells
        self.layer.cornerRadius = 20.0
        
        //add cell shadow
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.red.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }
    
}
