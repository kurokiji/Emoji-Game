//
//  IconCollectionViewCell.swift
//  Juego de niños
//
//  Created by Daniel Torres on 23/10/21.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    public static let identifier = "iconCell"
    
    @IBOutlet weak var iconLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with emoji: String) {
        iconLabel.text = emoji;
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "IconCollectionViewCell", bundle: nil)
    }

}
