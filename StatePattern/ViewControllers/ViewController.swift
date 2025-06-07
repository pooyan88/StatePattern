//
//  ViewController.swift
//  StatePattern
//
//  Created by Pooyan J on 3/17/1404 AP.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
        setupTableView()
        bindings()
    }
}

// MARK: - Setup Functions
extension ViewController {

    private func setupViewModel() {
        viewModel = ViewModel()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Binding
extension ViewController {

    func bindings() {
        bindLoading()
        bindTableView()
    }

    func bindLoading() {
        viewModel.showLoading
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isLoading in
                if isLoading {
                    activityIndicator.startAnimating()
                } else {
                    activityIndicator.stopAnimating()
                }
            }.store(in: &cancellables)
    }

    func bindTableView() {
        viewModel.reloadTableView
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

// MARK: - TableView Functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.setup(config: PostCell.Config(id: viewModel.posts[indexPath.row].id, title: viewModel.posts[indexPath.row].body))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCell.getHeight()
    }
}
