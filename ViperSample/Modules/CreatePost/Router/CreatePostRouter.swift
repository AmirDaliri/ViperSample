//
//  CreatePostRouter.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import UIKit
import RxCocoa

typealias CreatePostEntryPoint = CreatePostViewProtocol & UIViewController

// MARK: - CreatePostRouterProtocol
protocol CreatePostRouterProtocol {
    var entry: CreatePostEntryPoint? { get set }

    static func start(delegate: CreatePostDelegate, selectedUser: BehaviorRelay<UserEnum?>) -> CreatePostRouterProtocol

    func dismiss()
    func present(imagePicker: UIImagePickerController)
}

// MARK: - CreatePostRouter
class CreatePostRouter: CreatePostRouterProtocol {
    var entry: CreatePostEntryPoint?

    static func start(delegate: CreatePostDelegate, selectedUser: BehaviorRelay<UserEnum?>) -> CreatePostRouterProtocol {
        let router = CreatePostRouter()

        let view = CreatePostController.instantiateFromStoryboard
        let presenter = CreatePostPresenter()
        let interactor = CreatePostInteractor()

        view.presenter = presenter
        view.delegate = delegate
        view.selectedUser = selectedUser

        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor

        interactor.presenter = presenter

        router.entry = view

        return router
    }

    func dismiss() {
        entry?.dismiss(animated: true, completion: { [weak self] in
            self?.entry = nil
        })
    }

    func present(imagePicker: UIImagePickerController) {
        imagePicker.modalPresentationStyle = .fullScreen
        entry?.present(imagePicker, animated: true, completion: nil)
    }
}
