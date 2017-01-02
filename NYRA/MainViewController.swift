//
//  MainViewController.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var resolutions = [Resolution]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath)
        
        cell.layer.borderColor = UIColor.primrose().cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailVC")
        
        present(vc, animated: true, completion: nil)
    }
}