//
//  HomeTableViewCell.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifire: String = "HomeTableViewCell"

    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!


    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// MARK: - Public Method
extension HomeTableViewCell {
    func configure(with feed: Feed) {
        nameLabel.text = feed.user?.userId?.name
        usernameLabel.text = feed.user?.userId?.username
        captionLabel.text = feed.caption

        if let count = feed.commentCount, count > 0 {
            commentCountLabel.text = "\(count)"
        }

        if let count = feed.viewCount, count > 0 {
            viewCountLabel.text = "\(count)"
        }

        if let count = feed.likeCount, count > 0 {
            likeCountLabel.text = "\(count)"
        }

        if let image = feed.mediaImage {
            mediaImageView.image = image
        } else if let imageName = feed.media, imageName.count > 0 {
            mediaImageView.image = UIImage(named: imageName)
        } else {
            mediaImageView.image = nil
        }

        avatarImageView.image = UIImage(named: feed.user?.userId?.avatar ?? "")
    }
}
