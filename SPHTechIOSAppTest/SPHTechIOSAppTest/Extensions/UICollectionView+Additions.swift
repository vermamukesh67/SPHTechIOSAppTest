//
//  UICollectionView+Additions.swift
//  UpGradTest
//
//  Created by Mukesh Verma on 21/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation
import UIKit

open class ReusableCollectionViewCell: UICollectionViewCell {
    
    /// Reuse Identifier String
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    /// Registers the Nib with the provided table
    public static func registerWithCollectionView(_ collectionView: UICollectionView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier , bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
}
