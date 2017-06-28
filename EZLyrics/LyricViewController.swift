//
//  LyricViewController.swift
//  EZLyrics
//
//  Created by etudiant on 28/06/2017.
//  Copyright © 2017 EZ-iOs. All rights reserved.
//

import UIKit

class LyricViewController: UIViewController {
    
    @IBOutlet var lyricTextBlock: UITextView!
   
    let item: LyricFact
    let retriever: LyricRetriever = LyricRetriever()
    var lyric: String = ""
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, item: LyricFact) {
        self.item = item
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lyricTextBlock.text = "No lyric avaible for this song"
        retriever.getLyrics(item: self.item, block: {(lyric, error) in
            if(lyric?.isEmpty != true) {
                self.lyric = lyric!
                self.lyricTextBlock.text = lyric
            }
            else {
                self.lyricTextBlock.text = "No lyric avaible for this song"
            }
            
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    



}
