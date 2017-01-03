//
//  DetailViewController.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var resolutions = [Resolution]()
    var selectedIndex = 0
    var hasAppeared = false
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeAction(_ sender: UIButton, forEvent event: UIEvent) {
        dismiss(animated: true, completion: nil)
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resolutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionCell
        
        
        let keyboardAccessory = Bundle.main.loadNibNamed("NYRAKeyboardAccessory", owner: nil, options: nil)?[0] as! NYRAKeyboardAccessory
        keyboardAccessory.doneButton.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
        
        let resolution = resolutions[indexPath.row]
        
        cell.currentField.inputAccessoryView = keyboardAccessory
        
        cell.container.layer.borderColor = UIColor.primrose().cgColor
        cell.container.layer.borderWidth = 1
        cell.container.layer.cornerRadius = 3.0
        
        cell.nameLabel.text = resolution.name
        cell.currentField.text = "\(resolution.current)"
        cell.localGoal.text = "\(resolution.getLocalGoal())"
        cell.totalGoal.text = "\(resolution.getTotalGoal())"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if resolutions.count > 1 && selectedIndex <= resolutions.count - 1 && !hasAppeared {
            let index = IndexPath(item: selectedIndex, section: 0)
            detailCollectionView.scrollToItem(at: index, at: .left, animated: false)
            hasAppeared = true
        }
    }
}
