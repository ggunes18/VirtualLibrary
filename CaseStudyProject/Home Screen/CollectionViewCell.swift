//
//  CollectionViewCell.swift
//  CaseStudyProject
//
//  Created by Gizem on 28.07.2021.
//

import UIKit

//favourite protocol definition
protocol FavBookDelegate {
    func addToFavs(book: Book)
    func removeFromFavs(book: Book)
    func isFavourited(book: Book) -> Bool
}

class CollectionViewCell: UICollectionViewCell {
    var book : Book!
    var delegate : FavBookDelegate?
    
    //like button and action button for adding a book to favourites
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likeButton(_ sender: UIButton) {
        if let bookClicked = self.book {
            if !likeButton.isSelected {
                DispatchQueue.main.async {
                    self.delegate?.addToFavs(book: bookClicked)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.removeFromFavs(book: bookClicked)
                }
            }
        likeButton.isSelected = !likeButton.isSelected
        likeButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        }
    }
    
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

    
