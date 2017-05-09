//
//  Track.swift
//  Assignment
//
//  Created by Alaxabo on 4/11/17.
//  Copyright © 2017 Alaxabo. All rights reserved.
//

import Foundation

class Track {
    var name: String?
    var artist: String?
    var imageData: Data?
    var trackViewUrl: String?
    
    init(name: String?, artist: String?, artworkUrl100: String?, trackViewUrl: String?) {
        self.name = name
        self.artist = artist
        let url = URL(string: artworkUrl100!)
        self.imageData = try? Data(contentsOf: url!)
        self.trackViewUrl = trackViewUrl
    }
}
