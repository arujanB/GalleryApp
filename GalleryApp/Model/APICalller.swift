//
//  APICalller.swift
//  GalleryApp
//
//  Created by Aruzhan Boranbay on 30.03.2023.
//

import Foundation
import Alamofire

protocol APICallerDelegate {
    func didUpdateImageModelList(with modelList: [ImageModel])
    func didUpdateVideoModelList(with urlList: [String])
    func didFailWithError(_ error: Error)
}

struct APICaller{
    static var shared = APICaller()
    
    var delegate: APICallerDelegate?
    
    func fetchRequest(with query: String = "", mediaType: MediaType = .image, page: Int = 1) {
        switch mediaType {
            case .image:
                let urlString = "\(Constants.URLs.baseImageURL)?key=\(Constants.API.key)&q=\(query)&image_type=photo&page=\(page)"
            
//        https://pixabay.com/api/?key=34873339-0e0294130f05376be4779fa4f&q=galaxy+purple&image_type=photo&pretty=true
            AF.request(urlString).response { response in
                switch response.result {
                case .success(let data):
                    if let modelList = parseImageJSON(data!){
                        delegate?.didUpdateImageModelList(with: modelList)
                    }
                case .failure(let error):
                    delegate?.didFailWithError(error)
                }
            }
            case .video:
                let urlString = "\(Constants.URLs.baseVideoURL)?key=\(Constants.API.key)&q=\(query)&page=\(page)"
            AF.request(urlString).response { response in
                switch response.result {
                case .success(let data):
                    if let urlList = parseVideoJSON(data!){
                        delegate?.didUpdateVideoModelList(with: urlList)
                    }
                case .failure(let error):
                    delegate?.didFailWithError(error)
                }
            }
        }
    }
    
//    func fetchRequest(with query: String = "", mediaType: MediaType = .image) {
//        switch mediaType {
//            case .image:
//            //        let urlString = "\(Constants.Links.baseURL)?key=\(Constants.API.key)&q=\(query)&image_type=photo"
//                let urlString = "\(Constants.URLs.baseImageURL)?key=\(Constants.API.key)&q=\(query)&image_type=photo"
//                guard let url =  URL(string: urlString) else { return }
//
//                let task = URLSession.shared.dataTask(with: url) { data, _, error in
//                    //unwrap
//                    if let data, error == nil {
//                        if let modelList = parseImageJSON(data) {
//                            delegate?.didUpdateImageModelList(with: modelList)
//                            print(modelList)
//                        }else {
//                            delegate?.didFailWithError(error!)
//                        }
//                    }else {
//                        delegate?.didFailWithError(error!)
//                    }
//                }
//                task.resume()
//            case .video:
//            //        let urlString = "\(Constants.Links.baseURL)?key=\(Constants.API.key)&q=\(query)&image_type=photo"
//                let urlString = "\(Constants.URLs.baseVideoURL)?key=\(Constants.API.key)&q=\(query)"
//                guard let url =  URL(string: urlString) else { return }
//
//                let task = URLSession.shared.dataTask(with: url) { data, _, error in
//                    //unwrap
//                    if let data, error == nil {
//                        if let modelList = parseVideoJSON(data) {
//                            delegate?.didUpdateVideoModelList(with: modelList)
//                            print(modelList)
//                        }else {
//                            delegate?.didFailWithError(error!)
//                        }
//                    }else {
//                        delegate?.didFailWithError(error!)
//                    }
//                }
//                task.resume()
//        }
//    }

    func parseImageJSON(_ data: Data) -> [ImageModel]? {
        var modelList: [ImageModel] = []
        do{
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
            for imageData in decodedData.hits {
                let imageModel = ImageModel(previousURL: imageData.previousURL, lagerImageURL: imageData.lagerImageURL)
                print("IMG MODEL\(imageModel)")
                modelList.append(imageModel)
            }
        }catch{
            print(error)
        }
        return modelList
    }

    func parseVideoJSON(_ data: Data) -> [String]? {
        var modelList: [String] = []
        do{
            let decodedData = try JSONDecoder().decode(VideoData.self, from: data)
            for videoData in decodedData.hits {
                modelList.append(videoData.videos.medium.url)
            }
        }catch{
            print(error)
        }
        return modelList
    }
}
