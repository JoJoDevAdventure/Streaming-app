//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import UIKit

//MARK: - Protocols

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles : [Title] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // MARK: - Functions
    
    public func configure(with titles : [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    //CoreData download :
    private func downloadTitleAt(_ indexPath : IndexPath) {
        let title = titles[indexPath.row]
        DataPersistantManager.shared.downloadTitleWith(model: title) { result in
            switch result {
            case .success() :
                print("downloaded to the database")
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
         1-initialize ViewModel : TitlePreviewViewModel
         2-Youtube API CALL :
            If sucess => TitlePreviewModel with WebView
            else => TitlePreviewModel without WebView
         3-Delegate DidTapCell
         */
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = self.titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        guard let titleOverview = title.overview else {return }
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
            guard let strongSelf = self else { return }
            switch results {
            case . success(let videoElement) :
                
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel )
            case .failure(let error):
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title.release_date, voteCount: title.vote_count, voteAverge: title.vote_average)
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                print(error.localizedDescription)
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
                    let title = self?.titles[indexPath.row]
                    guard let titleName = title!.original_title ?? title!.original_name else {
                        return
                    }
                    guard let titleOverview = title?.overview else {return }
                    guard let strongSelf = self else { return }
                    APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
                        switch results {
                        case . success(let videoElement) :
                            let title = self?.titles[indexPath.row]
                            guard let titleOverview = title?.overview else { return }
                            let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: title?.release_date, voteCount: title?.vote_count, voteAverge: title?.vote_average)
                            self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel )
                        case .failure(let error):
                            let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: title?.release_date, voteCount: title?.vote_count, voteAverge: title?.vote_average)
                            self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                            print(error.localizedDescription)
                        }
                    }
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction, seeMoreAction])
        }
        return config
    }
}
