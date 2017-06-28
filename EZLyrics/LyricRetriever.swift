//
//  LyricRetriever.swift
//  EZLyrics
//
//  Created by etudiant on 07/06/2017.
//  Copyright © 2017 EZ-iOs. All rights reserved.
//

import UIKit

typealias RetrieveLyricsBlock = (Array<LyricFact>?, Error?) -> Void
typealias RetrieveLyricsSring = (String?, Error?) -> Void

class LyricRetriever: NSObject, XMLParserDelegate {
    static let BASE_API_URL = "http://api.chartlyrics.com/apiv1.asmx/"
    static let SEARCH_LYRIC_URL = "SearchLyric?"
    static let SEARCH_DIRECT_URL = "SearchLyricDirect?"
    static let GET_LYRIC = "GetLyric?"
    
    var foundCharacters:String = ""
    var items: [LyricFact] = []
    var item = LyricFact()
    var lyrics = String()
    
    func searchListByArtistSong(artist: String, song: String, block: @escaping RetrieveLyricsBlock) {
        let baseUri = LyricRetriever.BASE_API_URL + LyricRetriever.SEARCH_LYRIC_URL
        let fullUri = baseUri + "artist=" + artist + "&song=" + song
        let url = URL(string: fullUri)
        
        items.removeAll()
        
        let parser = XMLParser(contentsOf: url!)
        parser?.delegate = self
        var success: Bool
        
        success = (parser?.parse())!
        if success {
            print("parse success!")
            block(items, nil)
        }
        
    }
    
    func searchListByArtistSong(artist: String, song: String) {
        let baseUri = LyricRetriever.BASE_API_URL + LyricRetriever.SEARCH_LYRIC_URL
        let fullUri = baseUri + "artist=" + artist + "&song=" + song
        let url = URL(string: fullUri)
        
        let parser = XMLParser(contentsOf: url!)
        parser?.delegate = self
        var success: Bool
        
        success = (parser?.parse())!
        if success {
            print("parse success!")
            
        }
        
    }
    
    func getLyrics(item: LyricFact, block: @escaping RetrieveLyricsSring) {
        let baseUri = LyricRetriever.BASE_API_URL + LyricRetriever.GET_LYRIC
        let fullUri = baseUri + "lyricId=" + item.LyricId! + "&lyricCheckSum=" + item.LyricChecksum!
        let url = URL(string: fullUri)
        
        let parser = XMLParser(contentsOf: url!)
        parser?.delegate = self
        var success: Bool
        
        success = (parser?.parse())!
        if success {
            print("parse success!")
            block(lyrics, nil)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName=="SearchLyricResult")
        {
            if(elementName=="name"){
                print(elementName)
            }

        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(elementName=="Artist")
        {
            item.Artist = self.foundCharacters.replacingOccurrences(of: "\n", with: "")
            
        }
        if(elementName=="Song")
        {
            item.Song = self.foundCharacters.replacingOccurrences(of: "\n", with: "")
            
        }
        if(elementName=="TrackId")
        {
            item.TrackId = self.foundCharacters.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            
        }
        if(elementName=="LyricChecksum")
        {
            item.LyricChecksum = self.foundCharacters.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            
        }
        
        if(elementName=="LyricId")
        {
            item.LyricId = self.foundCharacters.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            
        }
        if(elementName == "Lyric"){
            lyrics = self.foundCharacters
            print(lyrics, "NotFound")
        }
        
        if(elementName == "SearchLyricResult") {
            let tempItem = LyricFact()
            tempItem.Artist = item.Artist
            tempItem.Song = item.Song
            tempItem.LyricChecksum = item.LyricChecksum
            tempItem.LyricId = item.LyricId
            tempItem.TrackId = item.TrackId
            self.items.append(tempItem)
        }
        
        
        
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
