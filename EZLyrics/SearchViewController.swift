//
//  SearchPageController.swift
//  EZLyrics
//
//  Created by etudiant on 18/05/2017.
//  Copyright © 2017 EZ-iOs. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var artistSearchBar: UISearchBar!
    @IBOutlet var songSearchBar: UISearchBar!
    @IBOutlet var resultTable: UITableView!
    
    let retriever: LyricRetriever = LyricRetriever()
    var lyricsFact: [LyricFact] = []
    
    var artistName: String = ""
    var songName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTable.delegate = self
        self.resultTable.dataSource = self
        self.artistSearchBar.delegate = self
        self.songSearchBar.delegate = self
        
        
        self.resultTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "itemCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchtext: String) {
        if(searchBar == artistSearchBar) {
            self.artistName = searchtext
        } else {
            self.songName = searchtext
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if(artistName.isEmpty != true && songName.isEmpty != true) {
            getItem()
        }
    }
    
    func getItem() {
        
        let songName = self.songName.replacingOccurrences(of: " ", with: "%20")
        let artistName = self.artistName.replacingOccurrences(of: " ", with: "%20")
        
        retriever.searchListByArtistSong(artist: artistName, song: songName, block: {(dataRetrieve, error) in
            self.lyricsFact.removeAll()
            if (dataRetrieve != nil) {
                dataRetrieve?.forEach({(item: LyricFact) in
                    self.lyricsFact.append(item)
                    
                    print(item.Artist ?? "Toto")
                    print(item.Song ?? "We Are the best")
                    print(item.LyricId ?? "default ID")
                    print(item.LyricChecksum ?? "Default CheckSum")
                })
            }
            DispatchQueue.main.async(execute: {
                self.resultTable.reloadData()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lyricsFact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        cell.textLabel?.text = self.lyricsFact[indexPath.row].Song
        cell.detailTextLabel?.text = self.lyricsFact[indexPath.row].Artist
        //cell.imageView?.image = UIImage(named: "owl")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lyrics = self.lyricsFact[indexPath.row]
        
        
        let lyricController = LyricViewController(nibName: "LyricViewController", bundle: nil, item: lyrics)
        
        self.navigationController?.pushViewController(lyricController, animated: true)
    }
    


}
