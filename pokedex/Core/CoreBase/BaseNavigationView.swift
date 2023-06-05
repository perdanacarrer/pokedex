//
//  BaseNavigationView.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit
import Stevia

open class BaseNavigationView: UIView {
    
    public let containerView = UIStackView()
    public let backButton = UIButton()
    public let Titlelabel = UILabel()
    public let rightButton = UIButton()
    public var callBack: (() -> Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(title: String, withBackButton: Bool = true, withRightButton: Bool = false, rightButtonTitle: String = "", didTapped: (() -> Void)? = nil) {
        self.init(frame: .zero)
        self.callBack = didTapped
        setupTitleLabel(title)
        setupBackButton(withBackButton)
        setUpRightButton(withRightButton: withRightButton, title: rightButtonTitle)
    }
    
    public func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setupConstraint()
        setupProperty()
        setupStyle()
    }
    
    open func setupHierarchy() {
        self.subviews {
            containerView.arrangedSubviews {
                backButton
                Titlelabel
                rightButton
            }
        }
    }
    
    open func setupConstraint() {
        containerView.fillHorizontally().fillVertically(padding: 4).height(56)
        containerView.right(16)
        backButton.height(48).width(48)
    }
    
    open func setupProperty() {
        UIApplication.topViewController()?.navigationController?.navigationBar.isHidden = true
        containerView.axis = .horizontal
        containerView.spacing = 8
        containerView.distribution = .fill
        Titlelabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - (backButton.widthConstraint?.constant ?? 0.0) - ((rightButton.widthConstraint?.constant ?? backButton.widthConstraint?.constant) ?? 0.0)
        self.backgroundColor = .white
        rightButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    open func setupStyle() {
        Titlelabel.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    open func setupTitleLabel(_ labelString: String) {
        self.Titlelabel.text = labelString
    }
    
    public func setupBackButton(_ withBackButton: Bool) {
        backButton.setImage(Asset.icArrowBefore.image, for: .normal)
        if withBackButton {
            if callBack != nil {
                self.backButton.isHidden = false
                backButton.addAction { [weak self] in
                    self?.didTappedBackButton()
                }
            } else {
                backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
                self.backButton.isHidden = false
            }
        } else {
            self.backButton.isHidden = true
        }
    }
    
    public func setUpRightButton(withRightButton: Bool, title: String) {
        rightButton.setTitleColor(.blue, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        rightButton.setTitle(title, for: .normal)
        rightButton.isHidden = !withRightButton
    }
    
    @objc public func backButtonAction(sender: UIButton!) {
        if let parentVC: UIViewController = UIApplication.topViewController() {
            if parentVC.isModal {
                parentVC.dismiss(animated: true)
            } else {
                parentVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc public func didTappedBackButton() {
        callBack?()
    }
}
