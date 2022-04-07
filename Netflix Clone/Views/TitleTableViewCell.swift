//
//  UpcomingTableViewCell.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 06/04/2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
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
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(upcomingPoster)
        addSubview(movieLabel)
        addSubview(playButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func applyConstraints() {
        let imageConstraints = [
            upcomingPoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            upcomingPoster.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            upcomingPoster.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            upcomingPoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let labelConstraints = [
            movieLabel.leadingAnchor.constraint(equalTo: upcomingPoster.trailingAnchor, constant: 30),
            movieLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -15),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let buttonConstriants = [
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(buttonConstriants)
    }
    
    public func configure(with model : TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        upcomingPoster.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.titleName
    }
    
}
