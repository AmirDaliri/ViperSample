//
//  HomeViewController.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/15/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

// MARK: - HomeViewProtocol
protocol HomeViewProtocol {
    var presenter: HomePresenterProtocol? { get set }

    func update(with feeds: BehaviorRelay<Home>)
    func filter(user: UserEnum?)
}

// MARK: - HomeViewController
class HomeViewController: UIViewController, HomeViewProtocol {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    var presenter: HomePresenterProtocol?
    var datasource = BehaviorRelay<[Feed]>(value: [])
    var selectedUser = BehaviorRelay<UserEnum?>(value: nil)
    var dispose = DisposeBag()

    static var instantiateFromStoryboard: HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
        bindData()
        presenter?.getFeeds(user: selectedUser.value)
    }

    // MARK: - Private Method
    private func setupTableView() {
        tableView.register(type: HomeTableViewCell.self)
    }

    private func setupNavigation() {
        title = "Feed"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(newPostAction))
        navigationItem.rightBarButtonItem?.tintColor = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterAction))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    private func bindData() {
        datasource.subscribe(onNext: { [weak self] feeds in
            self?.tableView.reloadData()
        }).disposed(by: dispose)

        selectedUser.subscribe(onNext: { [weak self] user in
            self?.presenter?.getFeeds(user: user)
        }).disposed(by: dispose)
    }

    // MARK: - Action
    @objc func filterAction() {
        presenter?.showFilterSheet()
    }

    @objc func newPostAction() {
        guard selectedUser.value != nil else {
            presenter?.showAlert(title: "Info", message: "You need select the user from Filter bar button in Navigation bar")
            return
        }
        presenter?.routeToCreatePost(selectedUser: selectedUser)
    }

    // MARK: - HomeViewProtocol
    func update(with feeds: BehaviorRelay<Home>) {
        datasource.accept(feeds.value.feeds)
    }

    func filter(user: UserEnum?) {
        selectedUser.accept(user)
    }
}

// MARK: - CreatePostDelegate
extension HomeViewController: CreatePostDelegate {
    func didAddNewPost(feed: Feed) {
        datasource.accept([feed] + datasource.value)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifire, for: indexPath) as! HomeTableViewCell
        let feed = datasource.value[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
