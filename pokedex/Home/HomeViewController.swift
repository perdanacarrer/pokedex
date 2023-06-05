//
//  HomeViewController.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit
import Stevia
import Kingfisher
import RxSwift
import RxCocoa

public class HomeViewController: BaseViewController {
    var presenter: HomePresentation?
    private var searchBarView: UIView = UIView()
    private var searchImageView: UIImageView = UIImageView()
    private var searchTextField: UITextField = UITextField()
    private let clearSearchButton: UIButton = UIButton()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var activityView: UIActivityIndicatorView?
    private let searchSubject = PublishSubject<String>()
    fileprivate let disposeBag = DisposeBag()

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
            searchBarView.subviews {
                searchImageView
                searchTextField
                clearSearchButton
            }
            collectionView
        }
    }
    
    private func setupConstraints() {
        searchBarView.Top == self.view.safeAreaLayoutGuide.Top
        searchBarView.Leading == view.Leading + 16
        searchBarView.Trailing == view.Trailing - 16

        searchImageView.width(24).height(24)
        searchImageView.Leading == searchBarView.Leading + 12
        searchImageView.Top == searchBarView.Top + 8
        searchImageView.Bottom == searchBarView.Bottom - 8

        searchTextField.Leading == searchImageView.Trailing + 12
        searchTextField.Trailing == clearSearchButton.Leading - 12
        searchTextField.Top == searchBarView.Top + 8
        searchTextField.Bottom == searchBarView.Bottom - 8

        clearSearchButton.height(24).width(24)
        clearSearchButton.CenterY == searchBarView.CenterY
        clearSearchButton.Trailing == searchBarView.Trailing - 12
        
        collectionView.Top == searchBarView.Bottom + 16
        collectionView.Bottom == view.safeAreaLayoutGuide.Bottom
        collectionView.Leading == view.Leading
        collectionView.Trailing == view.Trailing
    }
    
    private func setupAction() {
        clearSearchButton.addAction { [weak self] in
            self?.searchTextField.text = ""
            self?.clearSearchButton.isHidden = true
            self?.presenter?.bindSearchText()
//            self?.presenter?.onSearchPoke(keyword: self?.searchTextField.text ?? "")
        }
    }
    
    private func setupStyle() {
        self.view.backgroundColor = UIColor.white
        
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
        searchBarView.layer.cornerRadius = 4
        
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = Asset.icSearch.image
        
        searchTextField.placeholder = "Search"
        searchTextField.borderStyle = .none
        searchTextField.delegate = self
        
        clearSearchButton.setImage(Asset.icClose.image, for: .normal)
        clearSearchButton.isHidden = true
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
}

extension HomeViewController: HomeView {
    func showToast(_ text: String) {
        self.showToast(message: text, font: .systemFont(ofSize: 12.0))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
        self.view.isUserInteractionEnabled = false
    }

    func hideActivityIndicator() {
        if (activityView != nil){
            activityView?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func setSearchTextObservable() -> Observable<String> {
        return searchTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.dataCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: presenter?.filteredData?.smallImage?[indexPath.row] ?? "")
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.kf.setImage(with: url)
        cell.titleLabel.text = presenter?.filteredData?.displayName?[indexPath.row]
        cell.idLabel.text = presenter?.filteredData?.id?[indexPath.row]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInRows: CGFloat = 2
        let numberOfRows: CGFloat = 2
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
        presenter?.goToDetail(id: presenter?.filteredData?.id?[indexPath.row] ?? "")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.y / scrollView.frame.size.height)
        let pageInt = Int(round(pageFloat))
        let itemCountPerPage = 4
        let totalItemCount = presenter?.dataCount ?? 0
        let lastPage = (totalItemCount - 1) / itemCountPerPage
        let panGesture = scrollView.panGestureRecognizer
        let translation = panGesture.translation(in: scrollView)

        if totalItemCount > 0 {
            if pageInt <= 0 {
                // Detect swipe down gesture and scroll to the last page
                if !scrollView.isTracking && translation.y > 0 {
                    // Swipe down gesture detected
                    let lastIndexPath = IndexPath(item: totalItemCount - 1, section: 0)
                    collectionView.scrollToItem(at: lastIndexPath, at: .top, animated: false)
                    return
                }
            } else if pageInt >= lastPage - Int(0.25) {
                // Detect swipe up gesture and scroll to the first item
                if !scrollView.isTracking && translation.y < 0 {
                    let firstIndexPath = IndexPath(item: 0, section: 0)
                    collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: false)
                    return
                }
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBarView.layer.borderColor = UIColor.blue.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
            let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
            if fullString.count > 0 {
                clearSearchButton.isHidden = false
            } else {
                clearSearchButton.isHidden = true
            }
            presenter?.bindSearchText()
//            presenter?.onSearchPoke(keyword: fullString)
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
