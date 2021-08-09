//
//  BookDataSource.swift
//  CaseStudyProject
//
//  Created by Gizem on 28.07.2021.
//

import Foundation

protocol BookDataSourceDelegate {
    func BookListLoaded(bookList: [Book])
    func FullBookListLoaded(bookList: [Book])
}

class BookDataSource {
    var delegate : BookDataSourceDelegate?
    let baseURL = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/100/non-explicit.json"
    var pageInterval = 20
    var bookList : [Book] = []
    
    func loadListOfBooks(currentPage : Int){
        let session = URLSession.shared
        
        if let url = URL(string: baseURL){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = session.dataTask(with: request){
                (data, response, error) in
                let decoder = JSONDecoder()
                let feed = try! decoder.decode(Feed.self, from: data!)
                
                let page : Int = currentPage - 1
                if page * self.pageInterval < feed.feed.results.count{
                    for index in page*self.pageInterval...min(currentPage*self.pageInterval, feed.feed.results.count) - 1 {
                        self.bookList.append(feed.feed.results[index])
                    }
                }
                
                DispatchQueue.main.async {
                    self.delegate?.BookListLoaded(bookList: self.bookList)
                }
            }
            dataTask.resume()
        }
    }
    
    
    
    func loadListOfBooks() {
        let session = URLSession.shared
        var bookList : [Book] = []
        
        if let url = URL(string: baseURL){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = session.dataTask(with: request){
                (data, response, error) in
                let decoder = JSONDecoder()
                let feed = try! decoder.decode(Feed.self, from: data!)
                for item in feed.feed.results {
                    bookList.append(item)
                    
                }
                
                DispatchQueue.main.async {
                    self.delegate?.FullBookListLoaded(bookList: bookList)
                }
            }
            dataTask.resume()
        }
    }
    
}


