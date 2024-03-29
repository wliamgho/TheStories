//
//  SearchViewRouter.swift
//  TheStories
//
//  Created by Wil Liam on 7/1/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class SearchViewRouter: Router {
    var controller: UIViewController {
        let view = SearchViewController()
        let interactor = SearchViewInteractor()
        let presenter = SearchViewPresenter(view: view, interactor: interactor, router: self)
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.isNavigationBarHidden = true

        view.event = presenter
        interactor.output = presenter

        return navigationController
    }

    func pushToSearchDetailByType(navigationController: UINavigationController, searchTyped: String) {
        let searchDetail = SearchDetailRouter()
        navigationController.pushViewController(searchDetail.controller, animated: true)
    }
}
