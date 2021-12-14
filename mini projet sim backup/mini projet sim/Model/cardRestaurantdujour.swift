//
//  cardRestaurantdujour.swift
//  mini projet sim
//
//  Created by youssef benhissi on 02/01/2021.
//

import SwiftUI

struct CardRestaurantDuJour: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var offset: CGFloat = 0
    var title: String
}
