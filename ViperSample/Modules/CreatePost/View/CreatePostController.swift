//
//  CreatePostController.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

// MARK: - CreatePostViewProtocol
protocol CreatePostViewProtocol {
    var presenter: CreatePostPresenterProtocol? { get set }

    func didSelectImage(info: [UIImagePickerController.InfoKey: Any])
    func didAddPost(feed: Feed)
}

// MARK: - CreatePostDelegate
protocol CreatePostDelegate: AnyObject {
    func didAddNewPost(feed: Feed)
}

// MARK: - CreatePostController
class CreatePostController: UIViewController, CreatePostViewProtocol {

    // MARK: - Properties
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addMediaButton: UIButton!

    var dispose = DisposeBag()
    var presenter: CreatePostPresenterProtocol?

    weak var delegate: CreatePostDelegate?
    var selectedUser = BehaviorRelay<UserEnum?>(value: nil)

    static var instantiateFromStoryboard: CreatePostController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CreatePostController") as! CreatePostController
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        captionTextField.returnKeyType = .done
        captionTextField.delegate = self

        setupNavigation()
        bindData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        captionTextField.resignFirstResponder()
    }

    deinit {
        delegate = nil
        presenter = nil

        print("CreatePostController.deinit")
    }

    // MARK: - Private Methods
    private func setupNavigation() {
        title = "New Post"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(newPostAction))
        navigationItem.rightBarButtonItem?.tintColor = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    private func bindData() {
        mediaImageView.rx.isEmpty.subscribe(onNext: { [weak self] isEmpty in
            self?.addMediaButton.setTitle(isEmpty ? "Add Image" : "Change Image", for: .normal)
            self?.navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
        }).disposed(by: dispose)

        selectedUser.subscribe(onNext: { [weak self] user in
            self?.userImageView.image = UIImage(named: user?.avatar ?? "")
        }).disposed(by: dispose)
    }

    // MARK: - CreatePostViewProtocol
    func didSelectImage(info: [UIImagePickerController.InfoKey : Any]) {
        mediaImageView.image = info[.originalImage] as? UIImage
    }

    func didAddPost(feed: Feed) {
        print("add new post", feed)
        delegate?.didAddNewPost(feed: feed)
    }

    // MARK: - Action
    @objc func cancelAction() {
        presenter?.dismiss()
    }

    @objc func newPostAction() {
        guard let selectedUser = selectedUser.value else { return }
        let feed = Feed(user: User(userId: selectedUser), caption: captionTextField.text, mediaImage: mediaImageView.image)
        presenter?.post(feed: feed)
    }

    @IBAction func addImageAction(_ sender: Any) {
        presenter?.showImagePicker()
    }
}


extension CreatePostController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
