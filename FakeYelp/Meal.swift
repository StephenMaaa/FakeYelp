//
//  Meal.swift
//  FakeYelp
//
//  Created by Stephen Ma on 12/28/19.
//  Copyright © 2019 Stephen Ma. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var rating: Int
    var image: UIImage?
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: struct
    struct propertyKey {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    init?(name: String, rating: Int, image: UIImage?) {
        guard !name.isEmpty else {
            return nil
        }
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.rating = rating
        self.image = image
    }
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: propertyKey.name)
        coder.encode(image, forKey: propertyKey.image)
        coder.encode(rating, forKey: propertyKey.rating)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: propertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let image = coder.decodeObject(forKey: propertyKey.image) as? UIImage
        let rating = coder.decodeInteger(forKey: propertyKey.rating)
        
        self.init(name: name, rating: rating, image: image)
    }
}
