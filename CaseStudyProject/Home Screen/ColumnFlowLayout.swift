//
//  ColumnFlowLayout.swift
//  CaseStudyProject
//
//  Created by Gizem on 28.07.2021.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    let columnNo : Int
    var lengthRate : CGFloat = (3.0 / 2.0)
    
     init(columnNo : Int, minColumnGap : CGFloat = 0, minRowGap : CGFloat = 0) {
        self.columnNo = columnNo
        super.init()
        
        self.minimumInteritemSpacing = minColumnGap
        self.minimumLineSpacing = minRowGap
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {return}
        let gaps = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(columnNo-1)
        let itemWidth = ((collectionView.bounds.size.width - gaps) / CGFloat(columnNo)).rounded(.down)
        let itemHeight = itemWidth * lengthRate
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}
