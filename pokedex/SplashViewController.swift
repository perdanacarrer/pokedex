//
//  SplashViewController.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import UIKit
import Stevia

class SplashViewController: UIViewController {
    private var pokedexLbl: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierachy()
        setupContraints()
        setupStyle()
        setupAction()
    }
    
    private func setupViewHierachy() {
        view.subviews {
            pokedexLbl
        }
    }
    
    private func setupContraints() {
        pokedexLbl.CenterX == view.CenterX
        pokedexLbl.height(50)
        pokedexLbl.CenterY == view.CenterY
    }
    
    private func setupStyle() {
        pokedexLbl.text = "POKEDEX"
        pokedexLbl.font = UIFont.boldSystemFont(ofSize: 40.0)
        pokedexLbl.textColor = .blue
        view.backgroundColor = .white
    }
    
    private func setupAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NavigationManager.shared.navDelegate?.navigateToPage(NavigationDestination.pokedex.home, from: self)
        }
    }
}
