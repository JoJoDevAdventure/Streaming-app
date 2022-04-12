//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 10/04/2022.
//

import Foundation

struct YoutubeSearchResonse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
