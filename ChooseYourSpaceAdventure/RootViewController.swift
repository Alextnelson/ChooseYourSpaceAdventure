//
//  RootViewController.swift
//  ChooseYourSpaceAdventure
//
//  Created by Alexander Nelson on 4/11/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITextFieldDelegate {

    enum Error: ErrorType {
        case NoName
    }

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    if let pvc = segue.destinationViewController as? PageViewController {
                        pvc.page = Adventure.story(name)
                    }
                }
            } catch Error.NoName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start the adventure", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                presentViewController(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()

            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.8) {
            self.textFieldBottomConstraint.constant = 40.0
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    //Deprecated in iOS 9; remove before iOS 10
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
}

