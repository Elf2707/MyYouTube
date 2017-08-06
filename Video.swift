//
//  Video.swift
//  MyYouTube
//
//  Created by Elf on 08.07.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import Foundation
import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let firstCharacter = key.characters.first!
    
        var selectorStr = key
        if let range = selectorStr.range(of: String(firstCharacter)) {
            selectorStr.replaceSubrange(range, with: String(firstCharacter).uppercased())
        }
    
        let selector = NSSelectorFromString("set\(selectorStr):")
        let responds = self.responds(to: selector)
    
        if !responds {
            return
        }
        
        super.setValue(value, forKey: key)
    }
}

class Video: SafeJsonObject {
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            let channelDictionary = value as! [String : AnyObject]
            self.channel = Channel()
            channel?.setValuesForKeys(channelDictionary)
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(_ dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
