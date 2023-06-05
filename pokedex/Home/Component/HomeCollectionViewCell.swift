//
//  HomeCollectionViewCell.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit
import Stevia

final class HomeCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = UIImageView()
    let titleLabel: BaseLabel = BaseLabel(style: .headlineSemiBold)
    let idLabel: BaseLabel = BaseLabel(style: .headlineSemiBold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupHierarchy() {
        self.subviews {
            imageView
            titleLabel
            idLabel
        }
    }
    
    private func setupConstraints() {
        imageView.fillContainer(padding: 4)
        
        titleLabel.fillHorizontally(padding: 16).centerHorizontally().Top == imageView.Top + 16
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = true
        
        idLabel.fillHorizontally(padding: 16).centerHorizontally().Top == titleLabel.Bottom + 16
        idLabel.textAlignment = .center
        idLabel.numberOfLines = 0
        idLabel.isHidden = true
    }
}
