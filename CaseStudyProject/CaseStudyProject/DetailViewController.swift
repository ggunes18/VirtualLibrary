//
//  DetailViewController.swift
//  CaseStudyProject
//
//  Created by Gizem on 31.07.2021.
//

import UIKit

class DetailViewController: UIViewController{
    
    //variable declarations for book informations
    var name = ""
    var author = ""
    var date = ""
    var poster = UIImage()
    var book : Book!
    var favSet = Set<Book>()
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    //action button for redirecting user to search screen
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "BackToSearch", sender: self)
    }
    //action button for adding to or removing from favourites list
    @IBAction func favButton(_ sender: Any) {
        if favSet.contains(book) {
            favSet.remove(book)
            favButton.image = UIImage(systemName: "star")
        } else {
            favSet.insert(book)
            favButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookName.text = name
        bookAuthor.text = author
        releaseDate.text = date
        bookPoster.image = poster
        
        if favSet.contains(book) {
            favButton.image = UIImage(systemName: "star.fill")
        }else {
            favButton.image = UIImage(systemName: "star")
        }
    }

    //MARK: SEGUE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToSearch" {
            let vc : SearchViewController = segue.destination as! SearchViewController
            vc.favSet = favSet
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
 
