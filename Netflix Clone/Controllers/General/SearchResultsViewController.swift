//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 07/04/2022.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    public var titles : [Title] = []
    
    public let seachResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumLineSpacing = 12
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(seachResultsCollectionView)
        
        seachResultsCollectionView.delegate = self
        seachResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seachResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = seachResultsCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = titles[indexPath.row]
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        cell.contentView.addSubview(spinner)
        spinner.frame = cell.contentView.bounds
        cell.backgroundColor = .tertiaryLabel
        spinner.startAnimating()
        cell.configure(with: title.poster_path ?? "")
        spinner.stopAnimating()
        return cell
    }
}
