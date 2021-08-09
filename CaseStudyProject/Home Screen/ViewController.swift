//
//  ViewController.swift
//  CaseStudyProject
//
//  Created by Gizem on 28.07.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, BookDataSourceDelegate, FavBookDelegate {
    
    //variable declarations
    let bookDataSource = BookDataSource()
    var bookArray : [Book] = []
    var initialBookArray : [Book] = []
    var fullBookArray : [Book] = []
    var dateArray : [Date] = []
    var favSet = Set<Book>()
    var scroll = true
    var currentPage = 1
    
    
    //scroll view UI object and controller function for pagination
    @IBOutlet weak var scrollView: UIScrollView!
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height && scroll {
            currentPage += 1
            bookDataSource.loadListOfBooks(currentPage: currentPage)
        }
    }
    
    //action button and control statements for action sheet
    @IBAction func sortButton(_ sender: Any) {
        bookDataSource.loadListOfBooks()
        collectionView.reloadData()
        let sortMenu = UIAlertController(title: nil, message: "Sort books by: ", preferredStyle: .actionSheet)
        
        let all = UIAlertAction(title: "All books", style: .default, handler: {
                    (alert:UIAlertAction)-> Void in
            self.currentPage += 1
            self.bookDataSource.loadListOfBooks(currentPage: self.currentPage)
            self.scroll = true
        })
        
        let newToOld = UIAlertAction(title: "Newest first", style: .default, handler: { [self] (alert:UIAlertAction)-> Void in
            self.initialBookArray = self.bookArray
            bookDataSource.loadListOfBooks()
            self.bookArray = self.fullBookArray.sorted(by: {convertDate(dateString: $0.releaseDate) > convertDate(dateString: $1.releaseDate) })
            collectionView.reloadData()
            scroll = false
        })
        
        let oldToNew = UIAlertAction(title: "Oldest first", style: .default, handler: { [self] (alert:UIAlertAction)-> Void in
            self.initialBookArray = self.bookArray
            bookDataSource.loadListOfBooks()
            self.bookArray = self.fullBookArray.sorted(by: {convertDate(dateString: $0.releaseDate) < convertDate(dateString: $1.releaseDate) })
            collectionView.reloadData()
            scroll = false
        })
        
        let onlyLikes = UIAlertAction(title: "Favourites", style: .default, handler: { [self] (alert:UIAlertAction)-> Void in
            bookArray = initialBookArray
            bookArray = Array(self.favSet)
            collectionView.reloadData()
            scroll = false
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert:UIAlertAction)-> Void in
        }
        
        sortMenu.addAction(all)
        sortMenu.addAction(newToOld)
        sortMenu.addAction(oldToNew)
        sortMenu.addAction(onlyLikes)
        sortMenu.addAction(cancel)
                
        self.present(sortMenu, animated: true, completion: nil)
    }
    
    //search button action for redirecting user to search screen
    @IBAction func searchbutton(_ sender: Any) {
       performSegue(withIdentifier: "SearchScreen", sender: self)
    }
    
    //fav button action for redirecting user to favourites screen
    @IBAction func favScreenButton(_ sender: Any) {
        performSegue(withIdentifier: "FavScreen", sender: self)
    }
    
    //collection view declaration and viewDidLoad function
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks(currentPage: currentPage)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.collectionViewLayout = ColumnFlowLayout(columnNo: 2, minColumnGap: 10, minRowGap: 10)
    }
    
    
    //MARK: COLLECTION VIEW FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.delegate = self
        
        let book = bookArray[indexPath.row]
        let poster = getPosters(book: book)
        cell.bookName?.text = book.name
        cell.bookPoster?.image = poster
        cell.book = book
        
        if isFavourited(book: book) {
            cell.likeButton?.isSelected = true
        }else {
            cell.likeButton?.isSelected = false
        }
        cell.likeButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
        return cell
    }
    
    
    //MARK: BOOK DATA SOURCE FUNCTIONS
    func BookListLoaded(bookList: [Book]) {
        self.bookArray = bookList
        initialBookArray = bookArray
        self.collectionView.reloadData()
    }
    
    func FullBookListLoaded(bookList: [Book]) {
        self.fullBookArray = bookList
        self.collectionView.reloadData()
    }
    
    
    //MARK: SEGUE FUNCTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchScreen" {
            let vc = segue.destination as! SearchViewController
            vc.favSet = favSet
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
        if segue.identifier == "FavScreen" {
            let vc = segue.destination as! FavViewController
            vc.favSet = favSet
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    //MARK: FUNCTION FOR GETTING BOOK POSTERS FROM URLS
    func getPosters(book: Book) -> UIImage {
        var image : UIImage!
        if let posterURL = URL(string: book.artworkUrl100) {
            do {
                let data = try Data(contentsOf: posterURL)
                image = UIImage(data: data) ?? UIImage()
            } catch{}
        }
        return image
    }
    
    //MARK: FUNCTION FOR CONVERTING DATE STRINGS TO "DATE" OBJECTS
    func convertDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString) ?? Date()
        return date
    }
    
    
    //MARK: FAVOURITE FUNCTIONS AND SET

    func addToFavs(book: Book) {
        if !isFavourited(book: book) {
            favSet.insert(book)
            print("added")
        }
    }
    
    func removeFromFavs(book: Book) {
        if isFavourited(book: book) {
            favSet.remove(book)
            print("removed")
        }
    }
    
    func isFavourited(book: Book) -> Bool {
        return favSet.contains(book)
    }
}

    

