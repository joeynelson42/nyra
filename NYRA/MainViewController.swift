//
//  MainViewController.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var yearProgress: UIView!
    @IBOutlet weak var yearProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mainCollection: UICollectionView!
    var resolutions = [Resolution]()
    
    override func viewDidLoad() {
        
        let date = Date()
        let cal = Calendar.current
        if let day = cal.ordinality(of: .day, in: .year, for: date) {
            dayLabel.text = "DAY \(day)"
            yearProgressWidth.constant = CGFloat(day) / CGFloat(365) * Constants.screenWidth
        }
        
        CloudManager().fetchResolutions(completion: { fetchedResolutions in
            self.resolutions = fetchedResolutions
            
            DispatchQueue.main.async {
                self.mainCollection.reloadData()
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resolutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCollectionCell
        
        let resolution = resolutions[indexPath.row]
        
        cell.layer.borderColor = UIColor.primrose().cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3.0
        
        cell.nameLabel.text = resolution.name
        cell.currentLabel.text = "\(resolution.current)"
        cell.localGoalLabel.text = "\(resolution.getLocalGoal())"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
        vc.resolutions = resolutions
        vc.selectedIndex = indexPath.row
        
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth - 60, height: 123)
    }
}
