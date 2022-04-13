//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 07/04/2022.
//

import UIKit
import Lottie

//MARK: - Protocols

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel, title : Title)
}

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    
    public var titles : [Title] = []
    
    let doneDownloadAnimation = AnimationView()
    
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
        setupDownloadAnimation()
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
        view.addSubview(doneDownloadAnimation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seachResultsCollectionView.frame = view.bounds
    }
    
    
    private func setupDownloadAnimation() {
        doneDownloadAnimation.animation = Animation.named("done")
        doneDownloadAnimation.contentMode = .scaleAspectFit
        doneDownloadAnimation.loopMode = .playOnce
        doneDownloadAnimation.frame = view.bounds
        doneDownloadAnimation.isHidden = true
    }
    
    // MARK: - Functions
    
    
    private func downloadTitleAt(_ indexPath : IndexPath) {
        let title = titles[indexPath.row]
        DataPersistantManager.shared.downloadTitleWith(model: title) {[weak self] result in
            switch result {
            case .success() :
                NotificationCenter.default.post(name: NSNotification.Name("DownloadedItemFromHome"), object: nil)
                self?.playDoneDownloadAnimation()
            case .failure(let error) :
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
            }
        }
    }
    
    private func playDoneDownloadAnimation() {
        doneDownloadAnimation.isHidden = false
        let focus = UIFocusEffect()
        doneDownloadAnimation.focusEffect = .some(focus)
        doneDownloadAnimation.play {[weak self] done in
            if done {
                self?.doneDownloadAnimation.isHidden = true
            }else {
                
            }
        }
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
                self?.delegate?.searchResultsViewControllerDidTapItem(model, title: title)
            case .failure(let error) :
                let model = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                self?.delegate?.searchResultsViewControllerDidTapItem(model, title: title)
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
            }
        }
    }
    
    //Hold pressing cell :
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "download", image: UIImage(systemName: "arrow.down.to.line"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath)
                }
                
                let seeMoreAction = UIAction(title: "See mote", image: UIImage(systemName: "eye"), identifier: nil, discoverabilityTitle: nil, state: .off) {[weak self] _ in
                    guard let title = self?.titles[indexPath.row] else {return}
                    guard let titleName = title.original_title ?? title.original_name else {
                        return
                    }
                    guard let titleOverview = title.overview else {return }
                    APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
                        switch results {
                        case . success(let videoElement) :
                            guard let titleOverview = title.overview else { return }
                            let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                            self?.delegate?.searchResultsViewControllerDidTapItem(viewModel, title: title)
                        case .failure(let error):
                            let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                            self?.delegate?.searchResultsViewControllerDidTapItem(viewModel, title: title)
                            AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
                        }
                    }
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction, seeMoreAction])
        }
        return config
    }
    
}
