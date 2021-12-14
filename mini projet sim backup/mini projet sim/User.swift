//
//  User.swift
//  mini projet sim
//
//  Created by youssef benhissi on 30/11/2020.
//

import Foundation
import Alamofire
struct User: Decodable {

    
    let last_name: String?
    let first_name: String?
    let email: String?
    let etat:Int?
    let nbrdefois:Int?
    
    init(first_name:String, last_name:String ,email:String ,etat:Int,nbrdefois:Int)
    {
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.etat = etat
        self.nbrdefois = nbrdefois
  
    }
    
    
}
