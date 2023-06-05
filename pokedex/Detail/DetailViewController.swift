//
//  DetailViewController.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit
import Stevia
import Kingfisher

public class DetailViewController: BaseViewController {
    var presenter: DetailPresentation?
    private var navigationView: BaseNavigationView = BaseNavigationView(title: "")
    private let stackDetailView: UIStackView = UIStackView()
    private let stackContentView: UIStackView = UIStackView()
    private var contentView: UIView = UIView()
    private var overlayView: UIView = UIView()
    private var imageView: UIView = UIView()
    private var detailFullImageView: UIImageView = UIImageView()
    private var detailImageView: UIImageView = UIImageView()
    private let nameLabel: BaseLabel = BaseLabel(style: .bodySemiBold)
    private let typeHPLabel: BaseLabel = BaseLabel(style: .bodyRegular)
    private let superSubLabel: BaseLabel = BaseLabel(style: .bodyRegular)
    private let flavorLabel: BaseLabel = BaseLabel(style: .bodySemiBold)
    private let flavorTextLabel: BaseLabel = BaseLabel(style: .bodyItalic)
    private let otherCardsLabel: BaseLabel = BaseLabel(style: .bodySemiBold)
    private var searchTextField: UITextField = UITextField()
    private let clearSearchButton: UIButton = UIButton()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var activityView: UIActivityIndicatorView?
    private var currentPage: Int = 0

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupViewHierachy()
        setupConstraints()
        setupView()
        setupStyle()
        setupAction()
    }
    
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupViewHierachy() {
        view.subviews {
            navigationView
            overlayView.subviews {
                detailFullImageView
            }
            contentView.subviews {
                imageView.subviews {
                    detailImageView
                }
                nameLabel
                typeHPLabel
                superSubLabel
                flavorLabel
                flavorTextLabel
            }
            otherCardsLabel
            collectionView
        }
    }
    
    private func setupConstraints() {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        navigationView.centerHorizontally().fillHorizontally().Top == self.view.safeAreaLayoutGuide.Top
        navigationView.left(4).right(4)
        
        overlayView.Top == navigationView.Bottom
        overlayView.Bottom == view.Bottom
        overlayView.Leading == view.Leading
        overlayView.Trailing == view.Trailing
        
        detailFullImageView.centerHorizontally().Top == overlayView.Top + 64
        detailFullImageView.Bottom == overlayView.Bottom - 64
        detailFullImageView.Leading == overlayView.Leading + 16
        detailFullImageView.Trailing == overlayView.Trailing - 16
        
        contentView.Top == navigationView.Bottom
        contentView.Leading == view.Leading
        contentView.Trailing == view.Trailing

        imageView.height(screenHeight/2.84).Top == contentView.Top
        imageView.Leading == contentView.Leading
        imageView.Trailing == contentView.Trailing

        detailImageView.centerHorizontally().Top == imageView.Top
        detailImageView.Bottom == imageView.Bottom

        nameLabel.fillHorizontally(padding: 16).Top == imageView.Bottom + 16
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0

        typeHPLabel.fillHorizontally(padding: 16).Top == nameLabel.Bottom + 8
        typeHPLabel.textAlignment = .left
        typeHPLabel.numberOfLines = 0

        superSubLabel.fillHorizontally(padding: 16).Top == typeHPLabel.Bottom + 8
        superSubLabel.textAlignment = .left
        superSubLabel.numberOfLines = 0

        flavorLabel.fillHorizontally(padding: 16).Top == superSubLabel.Bottom + 8
        flavorLabel.textAlignment = .left
        flavorLabel.numberOfLines = 0

        flavorTextLabel.fillHorizontally(padding: 16).Top == flavorLabel.Bottom
        flavorTextLabel.textAlignment = .left
        flavorTextLabel.numberOfLines = 0

        otherCardsLabel.fillHorizontally(padding: 16).Bottom == collectionView.Top - 8
        otherCardsLabel.textAlignment = .left
        otherCardsLabel.numberOfLines = 0
        
        collectionView.height(screenHeight/4.26).Top == contentView.Bottom + 16
        collectionView.Bottom == view.safeAreaLayoutGuide.Bottom
        collectionView.Leading == view.Leading
        collectionView.Trailing == view.Trailing
    }
    
    private func setupAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        detailImageView.isUserInteractionEnabled = true
        detailImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerFull = UITapGestureRecognizer(target: self, action: #selector(imageTappedFull(tapGestureRecognizer:)))
        detailFullImageView.isUserInteractionEnabled = true
        detailFullImageView.addGestureRecognizer(tapGestureRecognizerFull)
    }
    
    private func setupStyle() {
        self.view.backgroundColor = UIColor.white
        
        overlayView.backgroundColor = .darkGray.withAlphaComponent(0.2)
        overlayView.isHidden = true
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.bringSubviewToFront(overlayView)
        overlayView.isHidden = false
    }
    
    @objc func imageTappedFull(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.sendSubviewToBack(overlayView)
        overlayView.isHidden = true
    }
}

extension DetailViewController: DetailView {
    
    func showToast(_ text: String) {
        self.showToast(message: text, font: .systemFont(ofSize: 12.0))
    }
    
    func setDetail(name: String, imageDetail: String, typeHP: String, superSub: String, flavorText: String) {
        navigationView.setupTitleLabel(name)
        
        let url = URL(string: imageDetail)
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.kf.setImage(with: url)
        
        detailFullImageView.contentMode = .scaleToFill
        detailFullImageView.kf.setImage(with: url)

        nameLabel.text(name)
        typeHPLabel.text(typeHP)
        superSubLabel.text(superSub)
        flavorLabel.text("Flavor :")
        flavorTextLabel.text(flavorText)
        otherCardsLabel.text("Other Cards")
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        self.view.bringSubviewToFront(activityView!)
        activityView?.startAnimating()
        self.view.isUserInteractionEnabled = false
    }

    func hideActivityIndicator() {
        if (activityView != nil){
            activityView?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.dataCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        let wrappedIndex = indexPath.row % (presenter?.dataCount ?? 0)
        let url = URL(string: presenter?.originalAssetListData?.smallImage?[wrappedIndex] ?? "")
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.kf.setImage(with: url)
        cell.titleLabel.text = presenter?.originalAssetListData?.displayName?[wrappedIndex]
        cell.idLabel.text = presenter?.originalAssetListData?.id?[wrappedIndex]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInRows: CGFloat = 2
        let numberOfRows: CGFloat = 1
        let width: CGFloat = collectionView.frame.size.width / numberOfItemsInRows
        let height: CGFloat = collectionView.frame.size.height / numberOfRows
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wrappedIndex = indexPath.row % (presenter?.dataCount ?? 0)
        presenter?.goToDetail(id: presenter?.originalAssetListData?.id?[wrappedIndex] ?? "")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        let itemCountPerPage = 2
        let totalItemCount = presenter?.dataCount ?? 0
        let lastPage = (totalItemCount - 1) / itemCountPerPage
        let panGesture = scrollView.panGestureRecognizer
        let translation = panGesture.translation(in: scrollView)

        if totalItemCount > 0 {
            if pageInt <= 0 {
                // Detect swipe left gesture and scroll to the last page
                if !scrollView.isTracking && translation.x > 0 {
                    // Swipe down gesture detected
                    let lastIndexPath = IndexPath(item: totalItemCount - 1, section: 0)
                    collectionView.scrollToItem(at: lastIndexPath, at: .left, animated: false)
                    return
                }
            } else if pageInt >= lastPage + Int(0.5) {
                // Detect swipe right gesture and scroll to the first item
                if !scrollView.isTracking && translation.x < 0 {
                    let firstIndexPath = IndexPath(item: 0, section: 0)
                    collectionView.scrollToItem(at: firstIndexPath, at: .left, animated: false)
                    return
                }
            }
        }
    }
}

