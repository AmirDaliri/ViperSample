//
//  HomeRouter.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/15/22.
//

import Foundation
import UIKit
import RxCocoa

typealias HomeEntryPoint = UIViewController & CreatePostDelegate

// MARK: - HomeRouterProtocol
protocol HomeRouterProtocol {
    var entry: HomeEntryPoint? { get set }

    static func start() -> HomeRouterProtocol

    func routeToCreatePost(selectedUser: BehaviorRelay<UserEnum?>)
    func presentSheet(vc: UIAlertController)
}

// MARK: - HomeRouter
class HomeRouter: HomeRouterProtocol {
    var entry: HomeEntryPoint?

    static func start() -> HomeRouterProtocol {
        let router = HomeRouter()

        let view = HomeViewController.instantiateFromStoryboard
        let presenter = HomePresenter()
        let interactor = HomeInteractor()

        view.presenter = presenter

        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor

        interactor.presenter = presenter

        router.entry = view

        return router
    }

    func routeToCreatePost(selectedUser: BehaviorRelay<UserEnum?>) {
        guard let entry = entry as? HomeViewController else { return }
        let createPostRouter = CreatePostRouter.start(delegate: entry, selectedUser: selectedUser)
        guard let createPostVC = createPostRouter.entry else { return }
        let navigationController = UINavigationController(rootViewController: createPostVC)
        navigationController.modalPresentationStyle = .fullScreen
        entry.present(navigationController, animated: true, completion: nil)
    }

    func presentSheet(vc: UIAlertController) {
        entry?.present(vc, animated: true, completion: nil)
    }
}
