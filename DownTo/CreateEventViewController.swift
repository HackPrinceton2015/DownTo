//
//  ViewController.swift
//  DownTo
//
//  Created by Christopher Fu on 11/14/15.
//  Copyright © 2015 HP2015. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var downToField: UITextField!
    @IBOutlet weak var meetAtField: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var pickerWrapperView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isPickerWrapperViewActive: Bool = true
    let pickerWrapperViewHeight: CGFloat = 260
    var timeValue: Int = 5

    let timeChoices = [5, 10, 15, 20, 25, 30]

    var client: MSClient!

    var myUser: User?
    var otherUsers: [User] = []
    var selectedUsers: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = UIColor.init(netHex: 0x0099FF)
        // Do any additional setup after loading the view, typically from a nib.
        timeButton.setTitle(String(timeValue), forState: UIControlState.Normal)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        myUser = delegate.myUser
        otherUsers = delegate.otherUsers
        client = delegate.client!

        downToField.layer.borderWidth = 1.0
        downToField.layer.borderColor = UIColor.blackColor().CGColor

        meetAtField.layer.borderWidth = 1.0
        meetAtField.layer.borderColor = UIColor.blackColor().CGColor

        let tap = UITapGestureRecognizer.init(target: self, action: Selector("dismissKeyboard:"))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        for _ in otherUsers {
            selectedUsers.append(false)
        }
    }

    func dismissKeyboard(sender: UITapGestureRecognizer) {
//        let point = sender.locationInView(self.view)
//        if !CGRectContainsPoint(tableView.frame, point) {
//            downToField.resignFirstResponder()
//            meetAtField.resignFirstResponder()
//        }
        downToField.resignFirstResponder()
        meetAtField.resignFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        if isPickerWrapperViewActive {
            dismissPickerWrapperView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("\(textField.text!)")
        return true
    }

    @IBAction func timeLabelTapped() {
        print("Time label tapped!")
        let oldFrame = pickerWrapperView.frame
        let oldOrigin = pickerWrapperView.frame.origin
        print("oldFrame: \(oldFrame)")
        print("oldOrigin: \(oldOrigin)")
        if !isPickerWrapperViewActive {
            showPickerWrapperView()
        }
        else {
            dismissPickerWrapperView()
        }
        print("new frame: \(pickerWrapperView.frame)")
    }

    @IBAction func dismissPickerWrapperView() {
        heightConstraint.constant = -pickerWrapperViewHeight
        UIView.animateWithDuration(0.1, animations: {
            self.view.layoutIfNeeded()
        })
        timeButton.setTitle(String(timeValue), forState: UIControlState.Normal)
        isPickerWrapperViewActive = false
    }

    @IBAction func showPickerWrapperView() {
        view.bringSubviewToFront(pickerWrapperView)
        heightConstraint.constant = 0
        UIView.animateWithDuration(0.1, animations: {
            self.view.layoutIfNeeded()
        })
        isPickerWrapperViewActive = true
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeChoices.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(timeChoices[row])
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeValue = timeChoices[row]
        timeButton.setTitle(String(timeValue), forState: UIControlState.Normal)
    }
    
    func animateTextFieldBorder(textField: UITextField) {
        let animation = CABasicAnimation.init(keyPath: "borderColor")
        animation.fromValue = UIColor.redColor().CGColor
        animation.toValue = UIColor.clearColor().CGColor
        animation.duration = 1
        textField.layer.addAnimation(animation, forKey: "borderColor")
    }

    @IBAction func createEvent() {
        print("calling createEvent")
//        activityIndicator.startAnimating()
        var valid = true
        if downToField.text == nil || downToField.text!.isEmpty {
            animateTextFieldBorder(downToField)
            valid = false
        }
        if meetAtField.text == nil || meetAtField.text!.isEmpty {
            animateTextFieldBorder(meetAtField)
            valid = false
        }
        if !valid {
            return
        }


        let itemTable = client.tableWithName("Events")
        print("\(itemTable)")

//        let usersTable = client.tableWithName("Users")
//        usersTable.readWithCompletion({
//            (result, error2) in
//            if error2 != nil {
//                print(error2)
//            }
//            else {
//                for item in result.items {
//                    if let name = item["name"] {
//                        let invItem: [String: AnyObject] =
//                            ["name": self.downToField.text!,
//                            "time": Int(self.timeButton.titleLabel!.text!)!,
//                            "location": self.meetAtField.text!,
//                            "receiver_userId": name!]
//                        let itemTable = self.client.tableWithName("Events")
//                        print("\(itemTable)")
//                        itemTable.insert(invItem) {
//                            (insertedItem, error) in
//                            if error != nil {
//                                print("Error \(error.description)")
//                            }
//                            else {
//                                print("Sent event: \(invItem)")
//                            }
//                        }
//                    }
//                    else {
//                        print("error")
//                    }
//                }
//                for (index, user) in
//            }
//        })
        for (index, user) in otherUsers.enumerate() {
            if selectedUsers[index] {
                print("adding event for user \(user.name)")
                let eventDict = Event.init(creator: myUser!, receiver: user, eventName: downToField.text!, eventLocation: meetAtField.text!, eventTime: Int((timeButton.titleLabel?.text)!)!).createDictionary()
                print(eventDict)
                itemTable.insert(eventDict) {
                    (insertedItem, error) in
                    if error != nil {
                        print("Error \(error.description)")
                    }
                    else {
                        print("Sent event: \(insertedItem)")
                    }
                }
            }
        }
        performSegueWithIdentifier("showAttendance", sender: self)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherUsers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("invitedUsersCell", forIndexPath: indexPath) as UITableViewCell
        myCell.textLabel?.text = otherUsers[indexPath.row].name
        return myCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedUsers[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedUsers[indexPath.row] = false
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedUsers[indexPath.row] = true
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "showAttendance" {
            let dest = segue.destinationViewController as! AttendanceViewController
            dest.myUser = myUser
            dest.otherUsers = otherUsers
            for (index, user) in dest.otherUsers.enumerate() {
                if selectedUsers[index] {
                    dest.invitedUsers.append(user)
                }
            }
            dest.locationName = meetAtField.text
            dest.eventName = downToField.text
            dest.initialTimeLeft = Int((timeButton.titleLabel?.text)!)!
            dest.timeLeft = Countdown.init(Int((timeButton.titleLabel?.text)!)!)
        }
    }
}

