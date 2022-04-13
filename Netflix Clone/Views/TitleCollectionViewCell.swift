//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 06/04/2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TitleCollectionViewCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
    }

    // MARK: - Set up
    
    private func setupSubViews(){
        contentView.addSubview(posterImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    //Configure Cell
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}
