//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    // MARK: - Properties
    
    var titles: [TitleItem] = []
    
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
        fetchLocalStorageForDownload()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Downloads"
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
    
    private func fetchLocalStorageForDownload() {
        DataPersistantManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.tableView.reloadData()
                }
            case.failure(let error) :
                print(error)
            }
        }
    }
    
}

// MARK: - Extensions

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? "unkown title", posterURL: titles[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        let titleOverview = title.overview ?? ""
        APICaller.shared.getMovie(with: titleName + " trailer") { results in
            switch results {
            case .success(let videoElement) :
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date,voteCount: Int(title.vote_count), voteAverge: title.vote_average)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    
}
