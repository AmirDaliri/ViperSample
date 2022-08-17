//
//  CreatePostPresenter.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import Foundation
import UIKit

// MARK: - CreatePostPresenterProtocol
protocol CreatePostPresenterProtocol {
    var router: CreatePostRouterProtocol? { get set }
    var interactor: CreatePostInteractorProtocol? { get set }
    var view: CreatePostViewProtocol? { get set }

    func showImagePicker()
    func post(feed: Feed)
    func dismiss()

    func addPostSuccessfully(feed: Feed)
}

// MARK: - CreatePostPresenter
class CreatePostPresenter: NSObject, CreatePostPresenterProtocol {

    var router: CreatePostRouterProtocol?
    var interactor: CreatePostInteractorProtocol?
    var view: CreatePostViewProtocol?

    func post(feed: Feed) {
        interactor?.post(feed: feed)
        dismiss()
    }

    func dismiss() {
        router?.dismiss()
        interactor = nil
        view = nil
    }

    func showImagePicker() {
        selectImageFrom(.photoLibrary)
    }

    func addPostSuccessfully(feed: Feed) {
        view?.didAddPost(feed: feed)
    }

    private func selectImageFrom(_ source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        router?.present(imagePicker: imagePicker)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreatePostPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        view?.didSelectImage(info: info)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
