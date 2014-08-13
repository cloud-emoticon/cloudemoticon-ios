//
//  ScoreTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/13.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController { //, UITableViewDelegate, UITableViewDataSource
    
    let fileMgr:FileManager = FileManager()
    var sfile:NSMutableArray = NSMutableArray.array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sfile.removeAllObjects()
        sfile.addObjectsFromArray(fileMgr.loadSources())
        if (sfile.count == 0) {
            let o_note:NSString = ""
            let o_name:NSString = "本地默认源"
            let o_url:NSString = "localhost"
            let o_delete:NSArray = ["default","system"]
            let s_emoset0:NSMutableArray = [o_note,o_name,o_url,o_delete]
            sfile.removeAllObjects()
            sfile.addObject("iOSv2")
            sfile.addObject(s_emoset0)
        } else {
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    

}
