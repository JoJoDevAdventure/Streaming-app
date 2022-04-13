//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var titles: [Title] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSubViews()
        fetchDiscoveredTvs()
        setupTableView()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self
    }
    
    private func setupSubViews() {
        view.addSubview(discoverTable)
    }
    
    private func setupTableView() {
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    // MARK: - Functions
    
    private func fetchDiscoveredTvs() {
        APICaller.shared.getDiscoverTv { [weak self] results in
            switch results {
            case .success(let titles) :
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Extensions

//TableView Extension
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let model = TitleViewModel(titleName: titles[indexPath.row].original_name ?? "unknown title", posterURL: titles[indexPath.row].poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  150
    }
    
}

//SearchView Extension
extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        guard let query = searchbar.text,
                  !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultsController.delegate = self
        APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles) :
                    resultsController.titles = titles
                    resultsController.seachResultsCollectionView.reloadData()
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
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
                    print(error.localizedDescription)
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


