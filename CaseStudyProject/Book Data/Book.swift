//
//  Book.swift
//  CaseStudyProject
//
//  Created by Gizem on 28.07.2021.
//

import Foundation

struct Book: Codable, Hashable {
    var artistName: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
}
