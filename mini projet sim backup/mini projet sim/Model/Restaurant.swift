//
//  Restaurant.swift
//  mini projet sim
//
//  Created by youssef benhissi on 08/12/2020.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI
// Model And Model Data..../Users/youssef/Desktop/mini projet sim backup/mini projet sim/View/RecentRestaurant.swift

struct Restaurant: Identifiable {
    
    var id = UUID().uuidString
    var name: String
    var price: String
    var image: String
    var rating : Int
    var description : String
    var region : String
    var adresse : String
    var nbrFois : Int
    var sommeRating : Int
    var imageD: String
    var imageT: String
    
    
}
class  observerReservation : ObservableObject  {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [commandeback]()
    init(idResto: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto
        ]
        AF.request(apiurl+"listcommandesswift", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                let json = try! JSON(data: data.data!)
                for i in json{
                    print([i.1])
                    self.datas.append(commandeback(id: i.1["id_commande"].intValue, name: i.1["first_name"].stringValue, message: i.1["total"].stringValue, messageadresse: i.1["adresse"].stringValue, profile: "p1", offset: 0))
                }
                        
                }
            }
        
           
        
    }
class  observerCommandes : ObservableObject  {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Message]()
    init(idResto: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto
        ]
        AF.request(apiurl+"listtablesswift", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                let json = try! JSON(data: data.data!)
                for i in json{
                    print([i.1])
                    self.datas.append(Message(id: i.1["id_table_resto"].intValue, name: i.1["first_name"].stringValue, message: i.1["date"].stringValue, profile: "p1", offset: 0))
                
                   
                }
                        
                }
            }
        
           
        
    }
    
    

class  observer : ObservableObject {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Restaurant]()
    init(){
        AF.request(apiurl+"listRestaurants").responseData{ (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.datas.append(Restaurant(id: i.1["id_resto"].stringValue,name: i.1["nom"].stringValue, price: i.1["adresse"].stringValue, image: i.1["image_pr"].stringValue, rating: i.1["nbr_etoiles"].intValue, description: i.1["description"].stringValue, region: i.1["region"].stringValue, adresse: i.1["adresse"].stringValue, nbrFois: i.1["nbr_defois"].intValue , sommeRating: i.1["somme_rating"].intValue, imageD: i.1["image_de"].stringValue , imageT: i.1["image_tr"].stringValue) )
               
            }
           
        }
    }
    
    
}
class  observerStatistiquesPlats : ObservableObject {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Stats]()
    init(idResto: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto
        ]
        AF.request(apiurl+"statistiquestables", method: .post, parameters: parameters, encoding: JSONEncoding.default)
             .responseJSON { (data) in
             let json = try! JSON(data: data.data!)
             for i in json{
                 
                 self.datas.append(Stats(id: 0, title: "Reservations", currentData: CGFloat(i.1["etat"].intValue), goal: 10, color: Color("waterstat")))
                
             }
            
         }
    }}
class  observerStatistiquesCommandes : ObservableObject {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Stats]()
    init(idResto: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto
        ]
        AF.request(apiurl+"statistiquescommandes", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.datas.append(Stats(id: 0, title: "Commandes", currentData: CGFloat(i.1["commandes"].intValue), goal: 10, color: Color("energystat")))
               
            }
           
        }
    }}
class  observerStatistiques : ObservableObject {
    var apiurl = "http://192.168.1.11:1337/"
    @Published var datas = [Stats]()
    init(idResto: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto
        ]
        AF.request(apiurl+"statistiquesplats", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.datas.append(Stats(id: 0, title: "Plats", currentData: CGFloat(i.1["nom"].intValue), goal: 10, color: Color("runningstat")))
               
            }
           
        }
        /*
       AF.request(apiurl+"statistiquestables", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.datas.append(Stats(id: 0, title: "Reservations", currentData: CGFloat(i.1["etat"].intValue), goal: 10, color: Color("waterstat")))
               
            }
           
        }
       
        AF.request(apiurl+"statistiquescommandes", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.datas.append(Stats(id: 0, title: "Commandes", currentData: CGFloat(i.1["commandes"].intValue), goal: 10, color: Color("energystat")))
               
            }
           
        }*/
    }
    
    
}



struct RestaurantItemW: View {
    @State var item: Restaurant
    var white = Color.white.opacity(0.85)
    @State var isModal: Bool = false
    @State var isModaldetail: Bool = false
    @State var show = false
    var body: some View {
        VStack(spacing: 35){
            
            AnimatedImage(url: URL(string: item.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            HStack{
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(item.name)
                        .foregroundColor(white)
                    
                    Text(item.price)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                VStack(alignment: .leading, spacing: 6) {
                    Button(action: {
                                        self.isModal = true
                                        
                                    }) {
                                        
                                        Image(systemName: "paperplane")
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                    }.sheet(isPresented: $isModal) {
                                        HomeCli()
                }
                    Button(action: {
                                        self.isModaldetail = true
                                        
                                    }) {
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                    }.sheet(isPresented: $isModaldetail) {
                                        Detail(selected: $item, show: $show)
                }}
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(
            
            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.black.opacity(0.35)]), startPoint: .top, endPoint: .bottom)
                .cornerRadius(25)
                .padding(.top,55)
        )
    }
}


