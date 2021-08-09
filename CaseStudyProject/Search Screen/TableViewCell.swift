//
//  TableViewCell.swift
//  CaseStudyProject
//
//  Created by Gizem on 31.07.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var bookPoster: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
