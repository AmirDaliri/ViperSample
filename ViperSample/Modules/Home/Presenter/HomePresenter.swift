//
//  HomePresenter.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/15/22.
//

import Foundation
import RxCocoa
import UIKit

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol {
    var router: HomeRouterProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var view: HomeViewProtocol? { get set }

    func showAlert(title: String?, message: String?)
    func showFilterSheet()
    func routeToCreatePost(selectedUser: BehaviorRelay<UserEnum?>)
    func getFeeds(user: UserEnum?)

    func interactorDidFetch(feeds: BehaviorRelay<Home>)
}

// MARK: - HomePresenter
class HomePresenter: HomePresenterProtocol {

    var router: HomeRouterProtocol?

    var interactor: HomeInteractorProtocol?

    var view: HomeViewProtocol?

    func getFeeds(user: UserEnum?) {
        interactor?.getFeeds(user: user)
    }

    func interactorDidFetch(feeds: BehaviorRelay<Home>) {
        view?.update(with: feeds)
    }

    func routeToCreatePost(selectedUser: BehaviorRelay<UserEnum?>) {
        router?.routeToCreatePost(selectedUser: selectedUser)
    }

    func showFilterSheet() {
        let alertController = UIAlertController(title: "Select User", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.view?.filter(user: nil)
        }))

        UserEnum.allCases.forEach { user in
            alertController.addAction(UIAlertAction(title: user.name, style: .default, handler: { [weak self] _ in
                switch user {
                case .emir:
                    self?.view?.filter(user: .emir)
                case .olivia:
                    self?.view?.filter(user: .olivia)
                case .emma:
                    self?.view?.filter(user: .emma)
                }
            }))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        router?.presentSheet(vc: alertController)
    }

    func showAlert(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        router?.presentSheet(vc: alertController)
    }
}
