//
//  FavViewController.swift
//  CaseStudyProject
//
//  Created by Gizem on 5.08.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favSet = Set<Book>()            //favourites set declaration
    
    @IBOutlet weak var tableView : UITableView!
    @IBAction func backToHome(_ sender: Any) {              //action button for redirecting user to home screen
        performSegue(withIdentifier: "FavBackToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    
    //MARK: TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FavTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavTableViewCell
        
        let book = Array(favSet)[indexPath.row]
        let poster = ViewController().getPosters(book: book)
        
        cell.bookName?.text = book.name
        cell.bookAuthor?.text = book.artistName
        cell.releaseDate?.text = book.releaseDate
        cell.bookPoster?.image = poster
        return cell
    }
    
    
    //MARK: SEGUE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavBackToHome" {
            let vc = segue.destination as! ViewController
            vc.favSet = favSet
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
