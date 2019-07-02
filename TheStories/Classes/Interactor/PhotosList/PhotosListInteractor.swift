//
//  PhotosListInteractor.swift
//  TheStories
//
//  Created by Wil Liam on 6/28/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class PhotosListInteractor: PhotosListInteractorInput {
    weak var output: PhotosListInteractorOutput?

    // Request search keyword
    func requestSearchByKeyword(keyword: String, startPage: Int, perPage: Int) {
        SearchService().searchByKeyword(withKeyword: keyword, pageNum: startPage, perPage: perPage) { [weak self] (response, error) in
            if let error = error {
                self?.output?.foundErrorRequest(error: error)
                return
            }

            guard let response = response, let result = response["results"] as? [[String: Any]] else {
                return
            }

            var photos = [Photo]()
            var imageModels = [ImageViewModel]()

            for data in result {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let photo = try JSONDecoder().decode(Photo.self, from: jsonData)

                    guard let photoURL = URL(string: photo.urls?.small ?? ""),
                        let smallPhoto = try? Data(contentsOf: photoURL) else {
                            debugPrint("No photo url")
                            return
                    }

                    // Get image
                    guard let image = UIImage(data: smallPhoto) else {
                        // No Image
                        return
                    }

                    imageModels.append(ImageViewModel(image: image))
                    photos.append(photo)
                } catch {
                    debugPrint("Data cannot be converted")
                }
            }

            // Output
            self?.output?.foundListPhotos(withPhotos: photos,
                                          page: perPage, imageModel: imageModels)
        }
    }

    // Request photos list
    func requestListPhotos(startPage: Int, perPage: Int) {
        PhotosService().listPhotos(pageNum: startPage, perPage: perPage) { [weak self] (response, error) in
            if let error = error {
                self?.output?.foundErrorRequest(error: error)
                return
            }

            var photos = [Photo]()
            var imageModels = [ImageViewModel]()

            guard let result = response else {
                self?.output?.foundListPhotos(withPhotos: photos,
                                              page: 0, imageModel: imageModels)
                return
            }

            // Added new item
            for data in result {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let photo = try JSONDecoder().decode(Photo.self, from: jsonData)

                    guard let photoURL = URL(string: photo.urls?.small ?? ""),
                        let smallPhoto = try? Data(contentsOf: photoURL) else {
                        debugPrint("No photo url")
                        return
                    }

                    // Get image
                    guard let image = UIImage(data: smallPhoto) else {
                        // No Image
                        return
                    }

                    imageModels.append(ImageViewModel(image: image))

                    photos.append(photo)
                } catch {
                    debugPrint("Data cannot be converted")
                }
            }

            self?.output?.foundListPhotos(withPhotos: photos,
                                          page: perPage, imageModel: imageModels)
        }
    }
}
