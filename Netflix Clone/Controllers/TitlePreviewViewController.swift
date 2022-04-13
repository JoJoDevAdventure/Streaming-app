//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 10/04/2022.
//

import UIKit
import WebKit
import Lottie

class TitlePreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentTitle : Title?
    
    var positifNote: Double = 0
    var negatifNote: Double = 0
    
    let doneDownloadAnimation = AnimationView()
    
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
        label.numberOfLines = 0
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
    
    let downloadBtn : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.addAction(UIAction(handler: {action in
            NotificationCenter.default.post(name: NSNotification.Name("PressedDownload"), object: nil)
        }), for: .touchUpInside)
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
        button.addAction(UIAction(handler: {action in
            NotificationCenter.default.post(name: NSNotification.Name("PressedPlay"), object: nil)
        }), for: .touchUpInside)
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
        setupObservers()
        setupDownloadAnimation()
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
        view.addSubview(doneDownloadAnimation)
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
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -10)
        ]
        
        let releaseDateLabeLConstraints = [
            releaseDateLabeL.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 30),
            releaseDateLabeL.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -10),
            overViewLabel.heightAnchor.constraint(equalToConstant:160)
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
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("PressedDownload"), object: nil, queue: nil) {[weak self] _ in
            self?.downloadTitle()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("PressedPlay"), object: nil, queue: nil) {[weak self] _ in
            self?.playTitle()
        }
    }
    
    private func setupDownloadAnimation() {
        doneDownloadAnimation.animation = Animation.named("done")
        doneDownloadAnimation.contentMode = .scaleAspectFit
        doneDownloadAnimation.loopMode = .playOnce
        doneDownloadAnimation.frame = view.bounds
        doneDownloadAnimation.isHidden = true
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
    
    private func downloadTitle() {
        guard let currentTitle = currentTitle else {
            return
        }
        DataPersistantManager.shared.downloadTitleWith(model: currentTitle) {[weak self] results in
            switch results {
            case .success() :
                NotificationCenter.default.post(name: NSNotification.Name("DownloadedItemFromHome"), object: nil)
                self?.playDoneDownloadAnimation()
            case .failure(let error) :
                AlertsManager.shared.errorAlert(with: self!, error: error.localizedDescription)
            }
        }
    }
    
    private func playTitle() {
        guard let currentTitle = currentTitle else {
            return
        }
        let vc = WatchStreamingUIViewController()
        vc.fetchWebView(with: currentTitle.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playDoneDownloadAnimation() {
        doneDownloadAnimation.isHidden = false
        let focus = UIFocusEffect()
        doneDownloadAnimation.focusEffect = .some(focus)
        doneDownloadAnimation.play {[weak self] done in
            if done {
                self?.doneDownloadAnimation.isHidden = true
            }
        }
    }
    
}
