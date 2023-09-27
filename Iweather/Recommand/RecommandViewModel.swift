//
//  RecommandViewModel.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/09/27.
//

import UIKit

class RecommandViewModel {
    var recommand: Recommand
    
    init(recommand: Recommand) {
        self.recommand = recommand
    }
    
    var comment: String {
        return recommand.comment
    }
    
    var menu: String {
        return recommand.menu
    }
    
    var backgroundImage: UIImage? {
        return recommand.backgroundImage
    }
    
    var recoImage: UIImage? {
        return recommand.recoImage
    }
}
