//
//  ExampleViewController.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 24.03.2023.
//

import UIKit
import SnapKit

class VideoViewController: UIViewController {
    private lazy var label: UILabel = {
        var label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpConstrains()
        view.backgroundColor = .green
    }

}

//MARK: - setUpViews & setUpConstrains
extension VideoViewController {
    func setUpViews() {
        view.addSubview(label)
    }
    
    func setUpConstrains(){
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
