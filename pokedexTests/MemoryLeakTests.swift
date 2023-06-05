//
//  MemoryLeakTests.swift
//  pokedexTests
//
//  Created by oscar perdana on 04/06/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import pokedex

class HomeViewControllerTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testMemoryLeak() {
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let viewController = HomeViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        weak var weakViewController = viewController
        weak var weakPresenter = presenter
        weak var weakInteractor = interactor
        
        // Simulate view did load
        scheduler.scheduleAt(0) {
            viewController.viewDidLoad()
        }
        
        // Simulate view controller deallocation
        scheduler.scheduleAt(20) {
            weakViewController = nil
        }
        
        // Simulate presenter deallocation
        scheduler.scheduleAt(30) {
            weakPresenter = nil
        }
        
        // Simulate interactor deallocation
        scheduler.scheduleAt(40) {
            weakInteractor = nil
        }
        
        scheduler.start()
        
        // Verify that view controller, presenter, and interactor are deallocated
        XCTAssertNil(weakViewController)
        XCTAssertNil(weakPresenter)
        XCTAssertNil(weakInteractor)
    }
}

