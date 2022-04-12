//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 07/04/2022.
//

import UIKit

//MARK: - Protocols

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    
    public var titles : [Title] = []
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let seachResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumLineSpacing = 12
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupCollectionView()
        setupNavBar()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupCollectionView () {
        seachResultsCollectionView.delegate = self
        seachResultsCollectionView.dataSource = self
    }
    
    private func setupSubViews() {
        view.addSubview(seachResultsCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seachResultsCollectionView.frame = view.bounds
    }

}

// MARK: - Extensions

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = seachResultsCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = titles[indexPath.row]
        cell.backgroundColor = .tertiaryLabel
        cell.configure(with: title.poster_path ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else { return }
        guard let titleOverview = title.overview else { return }
        APICaller.shared.getMovie(with: titleName + " trailer") {[weak self] results in
            switch results {
            case .success(let videoElement) :
                let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                self?.delegate?.searchResultsViewControllerDidTapItem(model)
            case .failure(let error) :
                let model = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                self?.delegate?.searchResultsViewControllerDidTapItem(model)
                print(error)
            }
        }
    }
    
}
