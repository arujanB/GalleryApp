//
//  DetailsViewController.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 06.04.2023.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var closeBtn: UIButton = {
        var button = UIButton()
        button.setTitle("Button", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(buttonIsTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.81)
        
        setUpViews()
        setUpConstrains()
    }
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: url)
        }
    }
    
    @objc func buttonIsTapped() {
        dismiss(animated: true)
    }
}

//MARK: - setUpViews & setUpConstrains
extension DetailsViewController{
    func setUpViews(){
        view.addSubview(imageView)
        view.addSubview(closeBtn)
    }
    
    func setUpConstrains(){
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(view.frame.size.width)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
