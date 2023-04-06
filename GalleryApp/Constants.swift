//
//  Constants.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 23.03.2023.
//

import Foundation
import UIKit

struct Constants{
    struct API {
        static let key = "34873339-0e0294130f05376be4779fa4f"
    }
    
    struct Identifiers{
        static let mediaCollectionViewCell = "MediaCollectionViewCell"
    }
    
    struct Values {
        static let screenWidth = UIScreen.main.bounds.height
    }
    
    struct URLs {
        static let baseImageURL = "https://pixabay.com/api/"
        static let baseVideoURL = "https://pixabay.com/api/video"
    }
}

enum MediaType: String {
    case image = "Image"
    case video = "Video"
}
