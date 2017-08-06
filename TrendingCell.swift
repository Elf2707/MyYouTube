//
//  TrendingCell.swift
//  MyYouTube
//
//  Created by Elf on 29.07.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingVideos() {
            videos in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
