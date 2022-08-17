//
//  CreatePostInteractor.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import Foundation

// MARK: - CreatePostInteractorProtocol
protocol CreatePostInteractorProtocol {
    var presenter: CreatePostPresenterProtocol? { get set }

    func post(feed: Feed)
}

// MARK: - CreatePostInteractor
class CreatePostInteractor: CreatePostInteractorProtocol {
    var presenter: CreatePostPresenterProtocol?

    func post(feed: Feed) {
        presenter?.addPostSuccessfully(feed: feed)
    }
}
