//
//  LyricRetriever.swift
//  EZLyrics
//
//  Created by etudiant on 07/06/2017.
//  Copyright © 2017 EZ-iOs. All rights reserved.
//

import UIKit

typealias RetrieveLyricsBlock = (Array<AnyObject>?, Error?) -> Void

class LyricRetriever: NSObject {
    static let BASE_API_URL = "http://api.chartlyrics.com/apiv1.asmx/"
    static let SEARCH_LYRIC_URL = "SearchLyric?"
    static let SEARCH_DIRECT_URL = "SearchLyricDirect?"
    static let GET_LYRIC = "GetLyric?"
    
    func searchListByArtistSong(artist: String, song: String, block: @escaping RetrieveLyricsBlock) {
        let baseUri = LyricRetriever.BASE_API_URL + LyricRetriever.SEARCH_LYRIC_URL
        let fullUri = baseUri + "artist=" + artist + "&song=" + song
        let url = URL(string: fullUri)
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if (error != nil) {
                block(nil, error)
            } else if (data != nil) {
                do {
                    let venueList = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let response = venueList["response"] as! NSDictionary
                    
                    if(response.count != 0) {
                        let venues = response["venues"] as! Array<AnyObject>
                        if(venues.count != 0) {
                            block(venues, nil)
                        }
                    }
                    
                } catch let errorEx {
                    block(nil, errorEx)
                }
            }
        })
        task.resume()
    }
    
}
