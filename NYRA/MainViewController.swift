//
//  MainViewController.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var yearProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mainCollection: UICollectionView!

    @IBOutlet weak var closeButton: UIButton!
    var mainLayout: UICollectionViewFlowLayout!
    var detailLayout: UICollectionViewFlowLayout!
    var keyboardAccessory: NYRAKeyboardAccessory!
    
    var resolutions = [Resolution]()
    var detailViewEnabled = false
    var saveTimer = Timer()
    
    override func viewDidLoad() {
        
        let date = Date()
        let cal = Calendar.current
        if let day = cal.ordinality(of: .day, in: .year, for: date) {
            dayLabel.text = "DAY \(day)"
            yearProgressWidth.constant = CGFloat(day) / CGFloat(365) * Constants.screenWidth
        }
        
        setupLayouts()
        
        keyboardAccessory = Bundle.main.loadNibNamed("NYRAKeyboardAccessory", owner: nil, options: nil)?[0] as! NYRAKeyboardAccessory
        keyboardAccessory.doneButton.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        syncCloud()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func syncCloud() {
        CloudManager().fetchResolutions(completion: { fetchedResolutions in
            self.resolutions = fetchedResolutions
            
            DispatchQueue.main.async {
                self.mainCollection.reloadData()
            }
        })
    }
    
    func setupLayouts() {
        detailLayout = UICollectionViewFlowLayout()
        detailLayout.scrollDirection = .horizontal
        detailLayout.itemSize = CGSize(width: Constants.screenWidth, height: Constants.screenHeight - 150)
        detailLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        detailLayout.minimumLineSpacing = 0
        
        mainLayout = UICollectionViewFlowLayout()
        mainLayout.scrollDirection = .vertical
        mainLayout.itemSize = CGSize(width: Constants.screenWidth - 60, height: 123)
        mainLayout.minimumLineSpacing = 10
        mainLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreateVC") as! CreateViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        if detailViewEnabled {
            detailViewEnabled = false
            mainCollection.setCollectionViewLayout(mainLayout, animated: true)
            mainCollection.isPagingEnabled = false
            UIView.animate(withDuration: 0.25, animations: { self.closeButton.alpha = 0 })
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resolutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionCell
        
        let resolution = resolutions[indexPath.row]
        
        cell.currentLabel.inputAccessoryView = keyboardAccessory
        
        cell.container.layer.borderColor = UIColor.primrose().cgColor
        cell.container.layer.borderWidth = 1
        cell.container.layer.cornerRadius = 3.0
        
        cell.nameLabel.text = resolution.name
        cell.currentLabel.text = "\(resolution.current)"
        cell.localGoalLabel.text = "\(resolution.getLocalGoal())"
        cell.totalGoalLabel.text = "\(resolution.getTotalGoal())"
        
        cell.upArrow.addTarget(self, action: #selector(increaseCurrent(_:)), for: .touchUpInside)
        cell.downArrow.addTarget(self, action: #selector(decreaseCurrent(_:)), for: .touchUpInside)
        
        cell.upArrow.tag = indexPath.row
        cell.downArrow.tag = indexPath.row
        
        cell.currentLabel.delegate = self
        cell.currentLabel.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !detailViewEnabled {
            detailViewEnabled = true
            collectionView.setCollectionViewLayout(detailLayout, animated: true)
            collectionView.isPagingEnabled = true
            UIView.animate(withDuration: 0.25, animations: { self.closeButton.alpha = 1 })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if detailViewEnabled {
            return CGSize(width: Constants.screenWidth, height: 418)
        } else {
            return CGSize(width: Constants.screenWidth, height: 165)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var resolution = resolutions[textField.tag]
        guard let currentString = textField.text else { return }
        guard let current = Int(currentString) else { return }
        resolution.current = current
        CloudManager().modifyResolution(res: resolution, completion: {
            print("saved!")
        })
    }
    
    func deleteAction(_ sender: UIButton) {
        let resolution = resolutions[sender.tag]
        resolutions.remove(at: sender.tag)
        mainCollection.reloadData()
        CloudManager().deleteResolution(res: resolution, completion: {
            self.syncCloud()
        })
    }
    
    func increaseCurrent(_ sender: UIButton) {
        modifyCurrent(index: sender.tag, change: 1)
    }
    
    func decreaseCurrent(_ sender: UIButton) {
        modifyCurrent(index: sender.tag, change: -1)
    }
    
    func modifyCurrent(index: Int, change: Int) {
        saveTimer.invalidate()
        
        let indexPath = IndexPath(item: index, section: 0)
        let cell = mainCollection.cellForItem(at: indexPath) as! DetailCollectionCell
        guard let currentText = cell.currentLabel.text else { return }
        guard let initialCurrent = Int(currentText) else { return }
        
        let newCurrent = initialCurrent + change
        cell.currentLabel.text = "\(newCurrent)"
        
        var resolution = resolutions[index]
        resolution.current = newCurrent
        
        fireTimer(res: resolution)
    }
    
    func fireTimer(res: Resolution) {
        saveTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {void in
            self.saveChanges(res: res)
        })
    }
    
    func saveChanges(res: Resolution) {
        CloudManager().modifyResolution(res: res, completion: {
            print("saved!")
        })
    }
}
