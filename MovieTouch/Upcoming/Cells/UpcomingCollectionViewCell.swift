//
//  UpcomingCollectionViewCell.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 02/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import UIKit

class UpcomingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgPoster: CustomImageView!
    @IBOutlet weak var lblReleased: UILabel!
    
    // MARK: - CollectionView Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgPoster.image = UIImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        DispatchQueue.main.async {
            self.imgPoster.image = UIImage()
        }
    }
}
