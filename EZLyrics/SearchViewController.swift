//
//  SearchPageController.swift
//  EZLyrics
//
//  Created by etudiant on 18/05/2017.
//  Copyright © 2017 EZ-iOs. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var resultTable: UITableView!
    
    let retriever: LyricRetriever = LyricRetriever()
    var lyricsFact: [LyricFact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retriever.searchListByArtistSong(artist: "Metallica", song: "Fuel", block: {(dataRetrieve, error) in
            if (dataRetrieve != nil) {
                dataRetrieve?.forEach({(item: LyricFact) in
                
                    print(item.Artist ?? "Toto")
                    print(item.Song ?? "We Are the best")
                    print(item.LyricId ?? "default ID")
                    print(item.LyricChecksum ?? "Default CheckSum")
                })
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
