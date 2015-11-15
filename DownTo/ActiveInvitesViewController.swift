//
//  ActiveInvitesViewController.swift
//  DownTo
//
//  Created by Christopher Fu on 11/14/15.
//  Copyright © 2015 HP2015. All rights reserved.
//

import UIKit

class Invite {
    var creatorName: String
    var time: NSDate
    var eventName: String
    
    init(creatorName: String, time: NSDate, eventName: String) {
        self.creatorName = creatorName
        self.time = time
        self.eventName = eventName
    }
    
}

class ActiveInvitesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    
    var invites: [Invite] = []
    var selectedIndex = 0
    
    var client: MSClient!
    
    override func viewDidLoad() {
        
        invites.append(Invite.init(creatorName: "Chris", time: NSDate.init(), eventName: "Lunch"))
        invites.append(Invite.init(creatorName: "Ryan", time: NSDate.init(), eventName: "Chill"))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        selectedIndex = indexPath.row
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return invites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("prototype1", forIndexPath: indexPath) as UITableViewCell
        
        myCell.textLabel?.text = "\(invites[indexPath.row].creatorName): Down 2 \(invites[indexPath.row].eventName)"
        myCell.detailTextLabel?.text = "Time"
        myCell.tag = indexPath.row
        
        return myCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController : ConfirmResponseViewController = segue.destinationViewController as! ConfirmResponseViewController
        destViewController.nameLabelText = invites[selectedIndex].creatorName
        //destViewController.timeLabelText =
        
        //let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
        
        //DestViewController.eventLabelText =
        //DestViewController.nameLabelText =
       // DestViewController.timeLabelText = myTableView.cellForRowAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>)
    }
    
    //This funcation gives a chance to access all events that the current user is invited to
    func update() {
        var list = []
        let usersTable = client.tableWithName("Events")
        //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"complete == NO"];
        usersTable.readWithCompletion({
            (result, error2) in
            if error2 != nil {
                print(error2)
            }
            else {
                for item in result.items {
                    if String(item["receiver_userid"]) == self.client.currentUser.userId
                    {
                        //list.append() <- item["name"/"time"/"location"/"creator_userid"/"_createdAt"]
                    }
                }
            }
        })
    }
    
    
    
    
}