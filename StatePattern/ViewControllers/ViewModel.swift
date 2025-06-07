//
//  ViewModel.swift
//  StatePattern
//
//  Created by Pooyan J on 3/17/1404 AP.
//

import Foundation
import Combine

final class ViewModel {

    enum State {
        case loading, success, failed
    }

    var posts: [PostResponse] = []
    var showLoading: CurrentValueSubject<Bool, Never> = .init(true)
    var reloadTableView = PassthroughSubject<Void, Never>()
    private var currentState: ViewModelState?

    init() {
        transition(to: LoadingState())
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getPosts()
        }
    }
}

// MARK: - Transition
extension ViewModel {
    private func transition(to state: ViewModelState) {
        self.currentState = state
        self.currentState?.enter(viewModel: self)
    }
}

// MARK: - API Call
extension ViewModel {

    private func getPosts() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await getPostsAPICall()
                await MainActor.run {
                    self.transition(to: SuccessState())
                    self.posts = response
                }
            } catch {
                transition(to: FailedState())
                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }

    private func getPostsAPICall() async throws -> [PostResponse] {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else {
            return []
        }
        let data = try await URLSession.shared.data(from: url).0
        let decodedData = try JSONDecoder().decode([PostResponse].self, from: data)
        print(decodedData)
        return decodedData
    }
}


protocol ViewModelState {
    func enter(viewModel: ViewModel)
}

final class LoadingState: ViewModelState {
    func enter(viewModel: ViewModel) {
        viewModel.showLoading.send(true)
    }
}

final class SuccessState: ViewModelState {
    func enter(viewModel: ViewModel) {
        viewModel.showLoading.send(false)
        viewModel.reloadTableView.send()
    }
}

final class FailedState: ViewModelState {
    func enter(viewModel: ViewModel) {
        viewModel.showLoading.send(false)
    }
}
