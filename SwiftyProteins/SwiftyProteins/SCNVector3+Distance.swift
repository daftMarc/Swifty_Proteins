//
//  SCNVector3+Distance.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 11/1/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
