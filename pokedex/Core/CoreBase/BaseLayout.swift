//
//  BaseLayout.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit
import Stevia

open class BaseLayout: UIViewController, UIScrollViewDelegate {
    var baseBackgroundColor: UIColor = .white
    
    public lazy var scrollViewContentWrapper: UIView = {
        let contentWrapper: UIView = UIView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.backgroundColor = baseBackgroundColor
        return contentWrapper
    }()
     
    public func createScrollView() -> UIScrollView {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsVerticalScrollIndicator = false
        scrollView.canCancelContentTouches = true
        scrollView.backgroundColor = .white
        return scrollView
    }
    
    public func setupScrollViewContraints(_ scrollView: UIScrollView, bgColor: UIColor = .white) {
        scrollViewContentWrapper.Top == scrollView.Top
        scrollViewContentWrapper.Bottom == scrollView.Bottom
        scrollViewContentWrapper.Leading == scrollView.Leading
        scrollViewContentWrapper.Trailing == scrollView.Trailing
        scrollViewContentWrapper.Width == scrollView.Width
        scrollViewContentWrapper.backgroundColor = bgColor
    }
    
    public func createCollectionView() -> UICollectionView {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = .zero
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        collectionViewLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        
        let collectionView: UICollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
}

public enum LabelStyle: RawRepresentable {
    public init?(rawValue: UIFont) {
        fatalError("Don't Do This")
    }
    
    public typealias RawValue = UIFont

    case headlineSemiBold
    case headlineBold
    case bodyRegular
    case bodySemiBold
    case bodyItalic

    public var rawValue: UIFont {
        switch self {
        case .headlineSemiBold:
            return UIFont.systemFont(ofSize: 14.0)
        case .headlineBold:
            return UIFont.boldSystemFont(ofSize: 16.0)
        case .bodyRegular:
            return UIFont.systemFont(ofSize: 12.0)
        case .bodySemiBold:
            return UIFont.boldSystemFont(ofSize: 14.0)
        case .bodyItalic:
            return UIFont.italicSystemFont(ofSize: 12.0)
        }
    }
}

public class BaseLabel: UILabel {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 12.0)
        self.textColor = UIColor.darkGray
    }
    
    public convenience init(style: LabelStyle) {
        self.init()
        self.font = style.rawValue
    }
    
    public convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    public convenience init(text: String, style: LabelStyle) {
        self.init()
        self.font = style.rawValue
        self.text = text
    }
    
    public convenience init(color: UIColor, style: LabelStyle) {
        self.init()
        self.textColor = color
        self.font = style.rawValue
        self.text = text
    }
    
    public convenience init(color: UIColor, style: LabelStyle, text: String) {
        self.init()
        self.textColor = color
        self.font = style.rawValue
        self.text = text
    }
}
