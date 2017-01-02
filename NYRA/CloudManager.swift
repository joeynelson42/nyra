//
//  CloudManager.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import Foundation
import CloudKit

class CloudManager {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    let idLength = 20
    
    func fetchResolutions(completion: @escaping ([Resolution]) -> Void) {
        let query = CKQuery(recordType: "Resolution", predicate: NSPredicate())
        privateDB.perform(query, inZoneWith: nil, completionHandler: { records, error in
            if let _ = error {
                print(error!)
                return
            }
            
            guard let resRecords = records else {
                completion([])
                return
            }
            
            var resolutions = [Resolution]()
            for record in resRecords {
                let fetchedRes = Resolution(id: record["ID"] as! String,
                                        name: record["Name"] as! String,
                                        recurrence: record["Recurrence"] as! String,
                                        frequency: record["Frequency"] as! Int64,
                                        notes: record["Notes"] as! String)
                resolutions.append(fetchedRes)
            }
            
            completion(resolutions)
        })
    }
    
    func saveResolution(res: Resolution) {
        
        var id = ""
        
        if res.id == "" {
            id = randomAlphaNumericString(length: idLength)
        } else {
            id = res.id
        }
        
        let resRecordID = CKRecordID(recordName: id)
        let resRecord = CKRecord(recordType: "Resolution", recordID: resRecordID)
        
        resRecord["Name"] = res.name as CKRecordValue
        resRecord["ID"] = id as CKRecordValue
        resRecord["Recurrence"] = res.recurrence as CKRecordValue
        resRecord["Frequency"] = res.frequency as CKRecordValue
        
        privateDB.save(resRecord, completionHandler: { savedRecord, error in
            if let _ = error {
                print(error!)
                return
            }
            
            print("successfully saved resolution")
        })
    }

    func deleteResolution(res: Resolution) {
        //use res.id to find CKRecord to delete
    }
    
    
    
    private func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}


