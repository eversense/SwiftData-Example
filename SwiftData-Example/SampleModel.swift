//
//  SampleModel.swift
//  SwiftData-Example
//
//  Created by Osamu Nishiyama on 2014/10/03.
//  Copyright (c) 2014年 ever sense. All rights reserved.
//

import Foundation

class SampleModel {
    
    init() {
        let (tb, err) = SD.existingTables()
        if !contains(tb, "samples") {
            if let err = SD.createTable("samples", withColumnNamesAndTypes: ["data": .StringVal]) {
                //there was an error during this function, handle it here
            } else {
                //no error, the table was created successfully
            }
        }
        println(SD.databasePath())
    }
    
    func add(data:NSDate) -> Int{
        var result: Int? = nil
        if let err = SD.executeChange("INSERT INTO samples (data) VALUES (?)", withArgs: [data]) {
            //there was an error during the insert, handle it here
        } else {
            //no error, the row was inserted successfully
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                //err
            }else{
                //ok
                result = Int(id)
            }
        }
        return result!
    }
    
    func delete(id:Int) -> Bool {
        if let err = SD.executeChange("DELETE FROM samples WHERE ID = ?", withArgs: [id]) {
            //there was an error during the insert, handle it here
            return false
        } else {
            //no error, the row was inserted successfully
            return true
        }
    }
    
    func getAll() -> NSMutableArray {
        var result = NSMutableArray()
        let (resultSet, err) = SD.executeQuery("SELECT * FROM samples ORDER BY ID DESC")
        let dateFormatter = NSDateFormatter()
        if err != nil {
            
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let dataStr = row["data"]?.asString()!
                    dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
                    let data = dateFormatter.dateFromString(dataStr!)
                    let dic = ["ID":id, "data":data!]
                    result.addObject(dic)
                }
            }
        }
        return result
    }
}

