//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 10/04/2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var positifNote: Double = 0
    var negatifNote: Double = 0
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()
    
    private let releaseDateLabeL: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = .label
        label.text = "Release date : 20/05/2022"
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight : .regular)
        label.numberOfLines = 0
        label.text = "best movie to watch as a kid"
        return label
    }()
    
    private let downloadBtn : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let playBtn : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "Votes (366) averge : "
        label.textColor = .label
        return label
    }()
    
    private let positifGreenView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private let negatifRedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private let pourcentageLikeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        return label
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        configureConstraints()
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabeL)
        view.addSubview(overViewLabel)
        view.addSubview(downloadBtn)
        view.addSubview(playBtn)
        view.addSubview(voteCountLabel)
        view.addSubview(positifGreenView)
        view.addSubview(negatifRedView)
        view.addSubview(pourcentageLikeLabel)
    }
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 280 )
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let releaseDateLabeLConstraints = [
            releaseDateLabeL.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 30),
            releaseDateLabeL.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -10),
            overViewLabel.heightAnchor.constraint(equalToConstant:150)
        ]
        
        let buttonConstraints = [
            downloadBtn.topAnchor.constraint(equalTo: releaseDateLabeL.bottomAnchor, constant: 30),
            downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70 ),
            downloadBtn.widthAnchor.constraint(equalToConstant: 120),
            downloadBtn.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let playButtonConstraints = [
            playBtn.topAnchor.constraint(equalTo: releaseDateLabeL.bottomAnchor, constant: 30),
            playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70 ),
            playBtn.widthAnchor.constraint(equalToConstant: 120),
            playBtn.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let voteCountLabelConstraints = [
            voteCountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            voteCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let positifGreenViewConstraints = [
            positifGreenView.widthAnchor.constraint(equalToConstant: positifNote*15),
            positifGreenView.heightAnchor.constraint(equalToConstant: 2.5),
            positifGreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            positifGreenView.centerYAnchor.constraint(equalTo: voteCountLabel.centerYAnchor)
        ]
        
        let negatifRedViewConstraints = [
            negatifRedView.widthAnchor.constraint(equalToConstant: negatifNote*15),
            negatifRedView.heightAnchor.constraint(equalToConstant: 2.5),
            negatifRedView.rightAnchor.constraint(equalTo: positifGreenView.leftAnchor, constant: 0 ),
            negatifRedView.centerYAnchor.constraint(equalTo: voteCountLabel.centerYAnchor)
        ]
        
        let pourcentageLikeLabelConstraints = [
            pourcentageLikeLabel.trailingAnchor.constraint(equalTo: positifGreenView.trailingAnchor, constant: 5),
            pourcentageLikeLabel.bottomAnchor.constraint(equalTo: positifGreenView.topAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(releaseDateLabeLConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(voteCountLabelConstraints)
        NSLayoutConstraint.activate(positifGreenViewConstraints)
        NSLayoutConstraint.activate(negatifRedViewConstraints)
        NSLayoutConstraint.activate(pourcentageLikeLabelConstraints)
    }
    
    // MARK: - Functions
    
    //Configure
    func configure(with model : TitlePreviewViewModel) {
        //Title
        titleLabel.text = model.title
        //Overview
        overViewLabel.text = model.titleOverview
        //WebView
        if model.youtubeView != nil {
            print("waiting")
            let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView!.id.videoId)")
            webView.load(URLRequest(url: url!))
        }
        //Release Date
        let date = model.releaseDate ?? "unknown"
        releaseDateLabeL.text = "Release date : \(date)"
        //Vote
        let voteAverge = model.voteAverge ?? 0
        positifNote = voteAverge
        negatifNote = voteAverge != 0 ? 10 - voteAverge : 0
        let voteCount = model.voteCount ?? 0
        let voteCountString = voteCount == 0 ? "N/A" : "\(voteCount)"
        voteCountLabel.text = "Votes (\(voteCountString)) averge : "
        pourcentageLikeLabel.text = "\(positifNote*10)%"
    }
    
    
}
