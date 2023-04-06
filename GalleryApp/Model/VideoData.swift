//
//  VideoData.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 30.03.2023.
//

import Foundation

struct VideoData: Decodable{
    let hits: [VideoHit]
    
    struct VideoHit: Decodable {
        let videos: Video
        
        struct Video: Decodable {
            let medium: Medium
            
            struct Medium: Decodable {
                let url: String
            }
        }
    }
}
