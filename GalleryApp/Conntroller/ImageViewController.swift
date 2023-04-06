//
//  ImageViewController.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 24.03.2023.
//

import UIKit

class ImageViewController: UIViewController {

    private lazy var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        let width = Constants.Values.screenWidth / 4.5
//        layout.itemSize = CGSize(width: width, height: width * 1.12)
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        
        setUpViews()
        setUpConstrains()
        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
    }

}

//MARK: - CollectionView DataSource
extension ImageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.mediaCollectionViewCell, for: indexPath) as! MediaCollectionViewCell
//        if mediaType == .image {
//            cell.backgroundColor = UIColor(red: 237/255, green: 248/255, blue: 235/255, alpha: 1)
//        }else {
//            cell.backgroundColor = UIColor(red: 30/255, green: 107/255, blue: 223/255, alpha: 0.2)
//        }
//        cell.configure(with: .image)
        cell.layer.cornerRadius = 13
        cell.layer.masksToBounds = true
        return cell
    }
}

//MARK: - CollectionView Delegate


//MARK: - CollectionView DelegateFlowLayout
extension ImageViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.06
        return CGSize(width: width, height: width * 1.12)
    }
}

//MARK: - setUpViews & setUpConstrains
extension ImageViewController{
    func setUpViews(){
        view.addSubview(mediaCollectionView)
    }
    
    func setUpConstrains(){
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview().inset(7)
        }
    }
}
