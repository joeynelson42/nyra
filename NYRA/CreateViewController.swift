//
//  CreateViewController.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

protocol CreateTableViewDelegate {
    func setNew(name: String)
    func setNew(recurrence: String)
    func setNew(frequency:String)
}

class CreateViewController: UIViewController, CreateTableViewDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    var resolution = Resolution()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedTableView" {
            let vc = segue.destination as! CreateTableViewController
            vc.createVCDelegate = self
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        resolution.notes = ""
        resolution.current = 0
        
        CloudManager().saveResolution(res: resolution, completion: { void in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func discardAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setNew(name: String) {
        resolution.name = name
    }
    
    func setNew(frequency: String) {
        guard let freq = Int(frequency) else { return }
        resolution.frequency = freq
    }
    
    func setNew(recurrence: String) {
        resolution.recurrence = recurrence
    }
}

class CreateTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dailyButton: NYRAButton!
    @IBOutlet weak var weeklyButton: NYRAButton!
    @IBOutlet weak var monthlyButton: NYRAButton!
    @IBOutlet weak var yearlyButton: NYRAButton!
    
    var keyboardAccessory: NYRAKeyboardAccessory!
    
    var recurrenceButtons = [NYRAButton]()
    var createVCDelegate: CreateTableViewDelegate!
    
    override func viewDidLoad() {
        
        keyboardAccessory = Bundle.main.loadNibNamed("NYRAKeyboardAccessory", owner: nil, options: nil)?[0] as! NYRAKeyboardAccessory
        keyboardAccessory.doneButton.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
        
        nameTextField.attributedPlaceholder =
            NSAttributedString(string: "NAME", attributes: [NSForegroundColorAttributeName : UIColor.primrose()])
        nameTextField.inputAccessoryView = keyboardAccessory
        nameTextField.addTarget(self, action: #selector(nameChanged(_:)), for: UIControlEvents.editingChanged)
        
        frequencyTextField.attributedPlaceholder =
            NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName : UIColor.primrose()])
        frequencyTextField.inputAccessoryView = keyboardAccessory
        frequencyTextField.addTarget(self, action: #selector(freqChanged(_:)), for: UIControlEvents.editingChanged)
        
        for subview in tableView.subviews {
            if subview.isKind(of: UIScrollView.self) {
                (subview as! UIScrollView).delaysContentTouches = false
            }
        }
        
        recurrenceButtons = [dailyButton, weeklyButton, monthlyButton, yearlyButton]
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    func nameChanged(_ sender: UITextField) {
        guard let name = sender.text else { return }
        createVCDelegate.setNew(name: name)
    }
    
    func freqChanged(_ sender: UITextField) {
        guard let freq = sender.text else { return }
        createVCDelegate.setNew(frequency: freq)
    }
    
    @IBAction func recurrenceAction(_ sender: UIButton) {

        for button in recurrenceButtons {
            if sender == button {
                button.drawGold()
            } else {
                button.pathLayer.removeFromSuperlayer()
            }
        }
        
        
        var labelText:NSString = ""
        var range = NSRange()
    
        if sender == dailyButton {
            labelText = "How many times a day will you do it?"
            range = labelText.range(of: "day")
            createVCDelegate.setNew(recurrence: "daily")
        } else if sender == weeklyButton {
            labelText = "How many times a week will you do it?"
            range = labelText.range(of: "week")
            createVCDelegate.setNew(recurrence: "weekly")
        } else if sender == monthlyButton {
            labelText = "How many times a month will you do it?"
            range = labelText.range(of: "month")
            createVCDelegate.setNew(recurrence: "monthly")
        } else if sender == yearlyButton {
            labelText = "How many times this year will you do it?"
            range = labelText.range(of: "year")
            createVCDelegate.setNew(recurrence: "yearly")
        }
        
        
        let attrString = NSMutableAttributedString(string: String(labelText), attributes: [NSForegroundColorAttributeName: UIColor.white])
        attrString.setAttributes([NSForegroundColorAttributeName: UIColor.primrose()], range: range)
        
        frequencyLabel.attributedText = attrString
    }
    
}
