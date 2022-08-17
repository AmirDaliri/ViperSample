//
//  HomeInteractor.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/15/22.
//

import Foundation
import RxCocoa

// MARK: - HomeInteractorProtocol
protocol HomeInteractorProtocol {
    var presenter: HomePresenterProtocol? { get set }

    func getFeeds(user: UserEnum?)
}

// MARK: - HomeInteractor
class HomeInteractor: HomeInteractorProtocol {
    var presenter: HomePresenterProtocol?

    func getFeeds(user: UserEnum?) {
        let emirPost = Feed(user: User(userId: .emir), caption: "Based on your input, get a random alpha numeric string. The random string generator creates a series of numbers and letters that have no pattern. These can be helpful for creating security codes.", media: "feed-1", timestamp: nil, commentCount: 12, viewCount: 500, likeCount: 256)
        let oliviaPost = Feed(user: User(userId: .olivia), caption: "Throughout time, randomness was generated through mechanical devices such as dice, coin flips, and playing cards.", media: "feed-2", timestamp: nil, viewCount: 100, likeCount: 8)
        let emmaPost = Feed(user: User(userId: .emma), caption: "In statistical theory, randomization is an important principle with one possible application involving survey sampling.", media: "feed-3", timestamp: nil, commentCount: 9, viewCount: 900, likeCount: 423)

        var feeds: [Feed] = []

        if let user = user {
            switch user {
            case .emir:
                feeds.append(emirPost)
            case .olivia:
                feeds.append(oliviaPost)
            case .emma:
                feeds.append(emmaPost)
            }
        } else {
            feeds.append(emirPost)
            feeds.append(oliviaPost)
            feeds.append(emmaPost)
        }

        let homeModel = BehaviorRelay<Home>(value: Home(feeds: feeds))
        presenter?.interactorDidFetch(feeds: homeModel)
    }
}
