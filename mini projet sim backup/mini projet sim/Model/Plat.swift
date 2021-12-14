//
//  Plat.swift
//  mini projet sim
//
//  Created by youssef benhissi on 27/11/2020.
//

import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI
import SwiftUI
struct Plat:Identifiable {
    var id = UUID().uuidString
    var title: String
    var cost: NSNumber
    var image: String
    var quantity: Int
    var idRestaurant: String
    var type: String
    //to idenitfy whether it is added to cart
    var isAdded : Bool = false
    var offset: CGFloat
    var isSwiped: Bool
}
class  observerPlat : ObservableObject {
    
    let parameters: [String: Any] = [
        "idRestaurant" : "1"]
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Plat]()
    init(){
        
        AF.request(apiurl+"listPlatsComplet", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { data in
            let json = try! JSON(data: data.data!)
            for i in json{
                //i.1["idRestaurant"].stringValue
                self.datas.append(Plat(title: i.1["nom"].stringValue, cost: i.1["prix"].numberValue , image: "shake1", quantity: 1, idRestaurant: i.1["idRestaurant"].stringValue, type: i.1["type_plat"].stringValue, offset: 0, isSwiped: false))
               
            }
           
        }
    }
    
    
}
