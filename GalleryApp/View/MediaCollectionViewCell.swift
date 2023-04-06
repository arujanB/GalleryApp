//
//  MediaCollectionViewCell.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 23.03.2023.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    private lazy var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "cat")
//        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.text = "Default"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ImageModel) {
        guard let url = URL(string: model.previousURL) else { return }
        DispatchQueue.main.async {
            self.img.contentMode = .scaleToFill
            self.img.kf.setImage(with: url)
        }
    }
    
    func configure() {
        DispatchQueue.main.async {
            self.img.contentMode = .scaleAspectFit
            self.img.image = UIImage(systemName: "player.circle.fill")
        }
    }
}

extension MediaCollectionViewCell {
    func setUpViews() {
        contentView.addSubview(img)
        contentView.addSubview(nameLabel)
    }
    
    func setUpConstrains() {
        img.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
//            make.height.equalTo(contentView.safeAreaLayoutGuide.snp.height).multipliedBy(0.7)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(img.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
    }
}
