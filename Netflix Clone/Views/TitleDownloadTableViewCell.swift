//
//  TitleDownloadTableViewCell.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 12/04/2022.
//

import UIKit
import Lottie

class TitleDownloadTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "TitleDownloadTableViewCell"
    
    private let upcomingPoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let DownloadAnimation: AnimationView = {
        let animatedDownload = AnimationView()
        animatedDownload.translatesAutoresizingMaskIntoConstraints = false
        animatedDownload.animation = Animation.named("download")
        animatedDownload.contentMode = .scaleAspectFit
        animatedDownload.loopMode = .loop
        animatedDownload.play()
        return animatedDownload
    }()
    
    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        applyConstraints()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        addSubview(upcomingPoster)
        addSubview(movieLabel)
        addSubview(DownloadAnimation)
    }
    
    //Constraints
    private func applyConstraints() {
        let imageConstraints = [
            upcomingPoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            upcomingPoster.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            upcomingPoster.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            upcomingPoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let labelConstraints = [
            movieLabel.leadingAnchor.constraint(equalTo: upcomingPoster.trailingAnchor, constant: 30),
            movieLabel.trailingAnchor.constraint(equalTo: DownloadAnimation.leadingAnchor, constant: -15),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let downloadAnimationConstriants = [
            DownloadAnimation.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            DownloadAnimation.widthAnchor.constraint(equalToConstant: 30),
            DownloadAnimation.heightAnchor.constraint(equalToConstant: 30),
            DownloadAnimation.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(downloadAnimationConstriants)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DownloadedItemFromHome"), object: nil, queue: nil ) { _ in
            self.DownloadAnimation.play()
        }
    }
    
    // MARK: - Functions
    
    public func configure(with model : TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        upcomingPoster.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.titleName
    }

}
 
