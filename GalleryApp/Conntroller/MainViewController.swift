//
//  ViewController.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 23.03.2023.
//

import UIKit
import AVKit
import SnapKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    private var imageModelList: [ImageModel] = []
    private var videoUrlList: [String] = []
    private var mediaType: MediaType = .image
    private var pageNumber = 1
    
    private lazy var segmentControll: UISegmentedControl = {
        var segmentControll = UISegmentedControl(items: [MediaType.image.rawValue, MediaType.video.rawValue])
        segmentControll.selectedSegmentIndex = 0
        segmentControll.addTarget(self, action: #selector(segmentControlValuChanged(_:)), for: .valueChanged)
        return segmentControll
    }()
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private lazy var mediaCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
//    //MARK: - SEGMENT
//    private var containerView = UIView()
//    
//    private var imageVC = ImageViewController()
//    private var videoVC = VideoViewController()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        APICaller.shared.fetchRequest(mediaType: .image)
        APICaller.shared.fetchRequest(mediaType: .video)
        APICaller.shared.delegate = self
        
        view.backgroundColor = .systemGray6
        searchBar.delegate = self
        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        
        setUpViews()
        setUpConstrains()
        
        configureNavBar()
    }
    
    @objc func segmentControlValuChanged(_ sender: UISegmentedControl){
        switch mediaType {
        case .image:
            mediaType = .image
            pageNumber = 1
            videoUrlList.removeAll()
        case .video:
            mediaType = .video
            pageNumber = 1
            imageModelList.removeAll()
        }
        APICaller.shared.fetchRequest(mediaType: mediaType)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
        
//        if sender.selectedSegmentIndex == 0 {
//            mediaType = .image
//            view.backgroundColor = .yellow
//            mediaCollectionView.reloadData()
//        }else {
//            mediaType = .video
//            view.backgroundColor = .purple
//            mediaCollectionView.reloadData()
//        }
    }
}

//MARK: - APICaller Protocol
extension MainViewController: APICallerDelegate {
    
    func didUpdateImageModelList(with modelList: [ImageModel]) {
        self.imageModelList.append(contentsOf: modelList)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func didUpdateVideoModelList(with modelList: [String]) {
        self.videoUrlList.append(contentsOf: modelList)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Error, it is not work", error)
    }
    
    
}

//MARK: - SearchBar delegate
extension MainViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()                       //drop the searchbatton after you pressing enter
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {// help search automatically when you write
        let query = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        print(query ?? "")
        APICaller.shared.fetchRequest(with: query ?? "")
    }
}

//MARK: - CollectionView DataSource
extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mediaType {
        case .image: return imageModelList.count
        case .video: return videoUrlList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell, for: indexPath) as! MediaCollectionViewCell
        if mediaType == .image {
            cell.backgroundColor = UIColor(red: 237/255, green: 248/255, blue: 235/255, alpha: 1)
            cell.configure(with: imageModelList[indexPath.row])
        }else {
            cell.backgroundColor = UIColor(red: 30/255, green: 107/255, blue: 223/255, alpha: 0.2)
            cell.configure()
        }
        cell.layer.cornerRadius = 13
        cell.layer.masksToBounds = true
        return cell
    }
}

//MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mediaType {
        case .image:
            let controller = DetailsViewController()
            controller.modalPresentationStyle = .overCurrentContext                                      // When it present it shows in full screen!!!
            controller.modalTransitionStyle = .crossDissolve                                             // Animation of showing the controller
            controller.configure(with: imageModelList[indexPath.item].lagerImageURL)
            present(controller, animated: true)
        case .video:
            guard let url = URL(string: videoUrlList[indexPath.item]) else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player
            controller.allowsPictureInPicturePlayback = true
            controller.player?.play()
            present(controller, animated: true)
        }
    }
}

//MARK: - CollectionView DelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.06
        return CGSize(width: width, height: width * 1.12)
    }
    
    //MARK: - infinity scrolling view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if offSetY > height - scrollView.frame.size.height {
            pageNumber += 1
            switch mediaType {
            case .image: APICaller.shared.fetchRequest(with: searchBar.text ?? "", mediaType: mediaType, page: pageNumber)
            case .video: APICaller.shared.fetchRequest(with: searchBar.text ?? "", mediaType: mediaType, page: pageNumber)
            }
        }
    }
}

////MARK: - Change SEGMENT
//extension MainViewController{
//    //segment
//    @objc func segmentControlValuChanged(_ sender: UISegmentedControl){
//        if sender.selectedSegmentIndex == 0 {
////            mediaType = .image
//            removeChildViewControllers(videoVC)
//            addChildViewControllers(imageVC)
//        }else {
////            mediaType = .video
//            removeChildViewControllers(imageVC)
//            addChildViewControllers(videoVC)
//        }
//    }
//
//    //Change VC
//    private func addChildViewControllers(_ viewController: UIViewController) {
//        addChild(viewController)
//        containerView.addSubview(viewController.view)
//        viewController.view.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        viewController.didMove(toParent: self)
//    }
//
//    private func removeChildViewControllers(_ viewController: UIViewController) {
//        viewController.willMove(toParent: nil)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParent()
//    }
//}

//MARK: - Navigation Bar Title
private extension MainViewController{
    func configureNavBar() {
        navigationItem.title = "Movies & Images"
    }
}

//MARK: - setUpViews & setUpConstrains
extension MainViewController{
    func setUpViews() {
        view.addSubview(segmentControll)
        view.addSubview(searchBar)
//        view.addSubview(containerView)
        view.addSubview(mediaCollectionView)
    }
    
    func setUpConstrains(){
        segmentControll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(7)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentControll.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
//        containerView.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(7)
        }
    }
}

