//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import UIKit
import Lottie

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Upcoming = 2
    case Popular = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var trendHeaderTitle : Title?
    var headerView : HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Upcoming movies",  "Popular", "Top rated"]
    
    let doneDownloadAnimation = AnimationView()
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupHeaderView()
        setupTableView()
        setupNavBar()
        setupObservers()
        setupDownloadAnimation()
    }
    
    // MARK: - Set up
    
    private func setupHeaderView() {
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
        fetchHeader()
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func setupTableView() {
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    private func setupSubViews() {
        view.addSubview(homeFeedTable)
        view.addSubview(doneDownloadAnimation)
    }
    
    private func setupNavBar() {
        
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func setupObservers() {
        //pressed play from header
        NotificationCenter.default.addObserver(forName: NSNotification.Name("PlayFromHeader"), object: nil, queue: nil) {[weak self] _ in
            guard let titleName = self?.trendHeaderTitle?.original_title ?? self?.trendHeaderTitle?.original_name else {
                return
            }
            guard let titleOverview = self?.trendHeaderTitle?.overview else { return }
            APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
                switch results {
                case . success(let videoElement) :
                    
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, releaseDate: self?.trendHeaderTitle?.release_date, voteCount: self?.trendHeaderTitle?.vote_count, voteAverge: self?.trendHeaderTitle?.vote_average)
                    DispatchQueue.main.async { [weak self] in
                        let vc = TitlePreviewViewController()
                        vc.configure(with: viewModel)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(_):
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: nil, titleOverview: titleOverview, releaseDate: self?.trendHeaderTitle?.release_date, voteCount: self?.trendHeaderTitle?.vote_count, voteAverge: self?.trendHeaderTitle?.vote_average)
                    DispatchQueue.main.async { [weak self] in
                        let vc = TitlePreviewViewController()
                        vc.configure(with: viewModel)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        //pressed Download from header
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DownloadedFromHeader"), object: nil, queue: nil ) {[weak self] _ in
            guard let trendHeaderTitle = self?.trendHeaderTitle else {
                return
            }
            DataPersistantManager.shared.downloadTitleWith(model: trendHeaderTitle) { Result in
                switch Result {
                case .success() :
                    NotificationCenter.default.post(name: NSNotification.Name("DownloadedItemFromHome"), object: nil)
                    self?.playDoneDownloadAnimation()
                case .failure(let error):
                    print(error)
                }
            }
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
    
    private func fetchHeader() {
        APICaller.shared.getTopRated { [weak self] Result in
            switch Result {
            case .success(let titles):
                self?.trendHeaderTitle = titles.randomElement()
                guard let poster = self?.trendHeaderTitle?.poster_path else { return }
                guard let trendTitles = self?.trendHeaderTitle else { return }
                self?.headerView?.currentTitle = trendTitles
                self?.headerView?.configure(with: poster)
            case .failure(let error):
                print(error.localizedDescription)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue :
            
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            
            }
            
        case Sections.TrendingTv.rawValue :
            
            APICaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            
            }
            
        case Sections.Popular.rawValue :
            
            APICaller.shared.getPopular { results in
                switch results {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            
            }
            
        case Sections.Upcoming.rawValue :
            
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            
            }
            
        case Sections.TopRated.rawValue :
            
            APICaller.shared.getTopRated { results in
                switch results {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            
            }
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y+defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellFinishedDownload() {
        playDoneDownloadAnimation()
    }
    
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel, title: Title) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.currentTitle = title
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
