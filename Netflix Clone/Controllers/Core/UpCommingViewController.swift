//
//  UpCommingViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import UIKit

class UpCommingViewController: UIViewController {
    
    // MARK: - Properties
    
    var UpcomingTitles: [Title] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSubViews()
        setupTableView()
        fetchUpcoming()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupSubViews() {
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Functions
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.UpcomingTitles = titles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Extensions

extension UpCommingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpcomingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: UpcomingTitles[indexPath.row].original_title ?? "unkown title", posterURL: UpcomingTitles[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = UpcomingTitles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        let titleOverview = title.overview ?? ""
        APICaller.shared.getMovie(with: titleName + " trailer") { results in
            switch results {
            case .success(let videoElement) :
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    vc.currentTitle = title
                    let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error) :
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    vc.currentTitle = title
                    let model = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                AlertsManager.shared.errorAlert(with: self, error: error.localizedDescription)
            }
        }
    }
    
}
