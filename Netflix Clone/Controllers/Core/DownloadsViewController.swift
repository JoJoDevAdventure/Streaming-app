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
        tableView.register(TitleDownloadTableViewCell.self, forCellReuseIdentifier: TitleDownloadTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSubViews()
        setupTableView()
        fetchLocalStorageForDownload()
        setupObservers()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete all", image: UIImage(systemName: "trash"), primaryAction: UIAction(handler: { _ in
            AlertsManager.shared.verificationAlert(with: self, sure: "remove all downloads?") {[weak self] confirm in
                if confirm {
                    self?.deleteAllLocalStorageForDownload()
                }
            }
        }), menu: nil)
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
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DownloadedItemFromHome"), object: nil, queue: nil ) { _ in
            self.fetchLocalStorageForDownload()
        }
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
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
            }
        }
    }
    
    private func deleteAllLocalStorageForDownload() {
        DataPersistantManager.shared.deleteAllTitles(items: titles) {[weak self] results in
            switch results {
            case .success() :
                self?.titles.removeAll()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error) :
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleDownloadTableViewCell.identifier, for: indexPath) as? TitleDownloadTableViewCell else { return UITableViewCell() }
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
                    vc.downloadBtn.isEnabled = false
                    let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date,voteCount: Int(title.vote_count), voteAverge: title.vote_average)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error) :
                AlertsManager.shared.errorAlert(with: self, error: error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            DataPersistantManager.shared.deleteTitileWith(model: titles[indexPath.row]) {[weak self] results in
                switch results {
                case .success() :
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
                }
            }
        default:
            break;
        }
    }

}
