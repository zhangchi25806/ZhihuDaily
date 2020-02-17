//
//  JsonDataModel.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/11.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//

import Foundation

struct JSONStoriesLatest: Codable {
    let date: String
    let stories: [JSONStories]
    let top_stories: [JSONTopStories]
}

struct JSONStoriesBefore: Codable {
    let date: String
    let stories: [JSONStories]
}

struct JSONStories: Codable {
    let image_hue: String
    let title: String
    let url: String
    let hint: String
    let ga_prefix: String
    let images: [String]
    let type: Int
    let id: Int
}

struct JSONTopStories: Codable {
    let image_hue: String
    let hint: String
    let url: String
    let image: String
    let title: String
    let ga_prefix: String
    let type: Int
    let id: Int
}
