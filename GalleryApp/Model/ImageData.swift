//
//  ImageData.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 30.03.2023.
//

import Foundation

struct ImageData: Decodable{
    let hits: [ImageHit]
    
    struct ImageHit: Decodable {
        let previousURL: String
        let lagerImageURL: String
    }
}
