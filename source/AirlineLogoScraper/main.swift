//
//  main.swift
//  AirlineLogoScraper
//
//  Created by Cal Stephens on 10/3/17.
//  Copyright © 2017 iOS Club. All rights reserved.
//

import Foundation
import AppKit

let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let airlineLogosFolder = URL(fileURLWithPath: documents.appending("/Airline Logos"))
try! FileManager.default.createDirectory(at: airlineLogosFolder, withIntermediateDirectories: true, attributes: nil)

let letters = ["A", "B", "C", "D", "E",
     "F", "G", "H", "I", "J", "K", "L",
     "M", "N", "O", "P", "Q", "R", "S",
     "T", "U", "V", "W", "X", "Y", "Z"]

let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

let characters = letters + numbers

func downloadLogo(_ icaoCode: String) {
    let semaphore = DispatchSemaphore(value: 0)
    
    let logoFetchUrl = URL(string: "https://flightaware.com/images/airline_logos/90p/\(icaoCode).png")!
    let logoFileUrl = airlineLogosFolder.appendingPathComponent("/\(icaoCode).png")
    
    URLSession.shared.dataTask(with: logoFetchUrl, completionHandler: { (data, _, _) -> Void in
        defer {
            semaphore.signal()
        }
        
        guard let data = data,
            NSImage(data: data) != nil else
        {
            print("nothing for \(icaoCode)")
            return
        }
        
        print("downloaded \(icaoCode)")
        try? data.write(to: logoFileUrl, options: [])
    }).resume()
    
    semaphore.wait()
}

for firstLetter in characters {
    downloadLogo("\(firstLetter)")
    for secondLetter in characters {
        downloadLogo("\(firstLetter)\(secondLetter)")
        for thirdLetter in characters {
            downloadLogo("\(firstLetter)\(secondLetter)\(thirdLetter)")
        }
    }
}


