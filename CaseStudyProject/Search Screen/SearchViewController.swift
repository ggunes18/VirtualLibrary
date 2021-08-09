//
//  SearchViewController.swift
//  CaseStudyProject
//
//  Created by Gizem on 29.07.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchViewController: UIViewController, BookDataSourceDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //variable declarations
    var favSet = Set<Book>()
    let bookDataSource = BookDataSource()
    var bookArray : [Book] = []
    var searchResult : [Book] = []
    var selectedIndex = Int()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func backButton(_ sender: Any) {     //back button for redirecting user to home page
        performSegue(withIdentifier: "BackToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        searchResult = bookArray
        searchBar.delegate = self
    }
    
    
    //MARK: TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        let book = searchResult[indexPath.row]
        let poster = ViewController().getPosters(book: book)
        
        cell.bookName?.text = book.name
        cell.bookAuthor?.text = book.artistName
        cell.releaseDate?.text = book.releaseDate
        cell.bookPoster?.image = poster
        return cell
    }
    
    //redirecting user to selected book's detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row 
        performSegue(withIdentifier: "DetailScreen", sender: self)
    }
    
    
    //MARK: BOOK DATA SOURCE FUNCTIONS
    func FullBookListLoaded(bookList: [Book]) {
        self.bookArray = bookList
        self.searchResult = bookList
        self.tableView.reloadData()
    }
    
    func BookListLoaded(bookList: [Book]) {
        self.bookArray = bookList
        self.searchResult = bookList
        self.tableView.reloadData()
    }
    
    //MARK: SEGUE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailScreen" {
            let vc = segue.destination as! DetailViewController
            
            vc.name = searchResult[selectedIndex].name
            vc.author = searchResult[selectedIndex].artistName
            vc.date = searchResult[selectedIndex].releaseDate
            vc.poster = ViewController().getPosters(book: searchResult[selectedIndex])
            vc.book = searchResult[selectedIndex]
            vc.favSet = favSet
            
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
        if segue.identifier == "BackToHome" {
            let vc : ViewController = segue.destination as! ViewController
            vc.modalPresentationStyle = .fullScreen
            vc.favSet = favSet
            present(vc, animated: true)
        }
    }
    
    //MARK: SEARCH BAR FUNCTION
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = []
        
        if searchText == "" {
            searchResult = bookArray //initial state
        }else {
            for book in bookArray {
                if book.name.lowercased().contains(searchText.lowercased()) {
                    searchResult.append(book)
                }
            }
        }
        self.tableView.reloadData()
    }
}

