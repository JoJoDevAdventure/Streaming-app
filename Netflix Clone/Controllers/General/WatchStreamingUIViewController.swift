//
//  WatchStreamingUIViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 13/04/2022.
//

import UIKit
import WebKit
import StreamingKit

class WatchStreamingUIViewController: UIViewController {
    
    // MARK: - Properties
    
    private let videoPlayer = StreamingVideoPlayer()
    
    private let greyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
//    private let webView: WKWebView = {
//        let configuration = WKWebViewConfiguration()
//        configuration.allowsInlineMediaPlayback = true
//        configuration.mediaTypesRequiringUserActionForPlayback = .audio
//        let webV = WKWebView(frame: .zero, configuration: configuration)
//        webV.contentMode = .scaleAspectFit
//        webV.allowsBackForwardNavigationGestures = true
//        webV.configuration.allowsInlineMediaPlayback = true
//        webV.translatesAutoresizingMaskIntoConstraints = false
//        return webV
//    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        applyConstraints()
        setupVideoPlayer()
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
//        view.addSubview(webView)
        view.addSubview(greyView)
    }
    
    private func setupVideoPlayer() {
        videoPlayer.add(to: greyView)
    }
    
    private func applyConstraints() {
//        let constraints = [
//            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            webView.heightAnchor.constraint(equalToConstant: 300),
//            webView.widthAnchor.constraint(equalTo: view.widthAnchor)
//        ]
        
        let viewConstraints = [
            greyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greyView.heightAnchor.constraint(equalToConstant: view.frame.height/3),
            greyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
//        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    public func fetchWebView(with id : Int) {
        let base = "https://imdbembed.xyz/movie/tmdb/"
        guard let url = URL(string:"\(base)\(id)") else { return }
//        print(url)
//        webView.load(URLRequest(url: url!))
        videoPlayer.play(url: url)
    }
    

}

// MARK: - Extensions
