//
//  FavTableViewCell.swift
//  CaseStudyProject
//
//  Created by Gizem on 5.08.2021.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var bookPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
