//
//  SearchViewEvent.swift
//  TheStories
//
//  Created by Wil Liam on 7/1/19.
//  Copyright © 2019 William. All rights reserved.
//

import Foundation

protocol SearchViewEvent: class {
    func onSearch(keyword: String, startPage: Int, perPage: Int)

    func searchTypeDidTapped(viewController: SearchViewController, selectedType: String)
}
