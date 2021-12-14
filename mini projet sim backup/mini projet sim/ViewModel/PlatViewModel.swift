//
//  PlatViewModel.swift
//  mini projet sim
//
//  Created by youssef benhissi on 27/11/2020.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import CoreLocation
class  PlatViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    @Published var categorieplat = ""
    @Published var search = ""
    @Published var locationManager = CLLocationManager()
    @Published var userLoction : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    @Published var existantetFavoris = false
    @Published var code = 0
    @Published var nouveauemotdepasse = ""
    @Published var resvationString = ""
    @Published var loginString = ""
    @Published var ratingString = ""
    @Published var etatLogin : Int!
    @Published var modelLogin = false
    var apiurl = "http://192.168.1.11:1337/"
    @Published var items = [Plat]()
    @Published var filtered:  [Plat] = []
    @Published var ordered = false
    @Published var itemsPosts = [Post]()
    @Published var itemsRestaurants = [Restaurant]()
    @Published var cartItems : [Cart] = []
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //checking location access
        switch manager.authorizationStatus{
            case .authorizedWhenInUse:
                print("authorized")
                self.noLocation=false
                manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
//    default:/Users/youssef/Desktop/mini projet sim backup/mini projet sim/GoogleDelegate.swift
            print("unknown")
            self.noLocation = false
            //Direct Call
            locationManager.requestWhenInUseAuthorization()
            
            self.fecthData()
            self.filtered = self.items
        default: break
        }
        
    }
    
    override init() {
        super.init()
        fecthDataPosts()
        afficherRecents(idClient: "8")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //reading location details
        self.userLoction = locations.last
        self.extractLoction()
    }
    func extractLoction(){
        CLGeocoder().reverseGeocodeLocation(self.userLoction){
            (res,err) in
            guard let safeData = res else {
                return
            }
            var address = ""
            address += safeData.first?.name ?? ""
            address += ", "
            address +=  safeData.first?.locality ?? ""
            self.userAddress = address
        }
    }
    func fecthData(){
        let parameters: [String: Any] = ["idRestaurant" : "1"]
        AF.request(apiurl+"listPlatsComplet", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { data in
            let json = try! JSON(data: data.data!)
            for i in json{
                //i.1["idRestaurant"].stringValue
                self.items.append(Plat(title: i.1["nom"].stringValue, cost: i.1["prix"].numberValue , image: i.1["image"].stringValue, quantity: 1, idRestaurant: i.1["idRestaurant"].stringValue, type: i.1["type_plat"].stringValue, offset: 0, isSwiped: false))
                print(i.1)
               
            }
           
        }
    }
    func fecthDataPosts(){
        AF.request(apiurl+"listRestaurants").responseData{ (data) in
            let json = try! JSON(data: data.data!)
            for i in json{
                
                self.itemsPosts.append(Post(id: Int(i.1["id_resto"].numberValue), name: i.1["nom"].stringValue, url: i.1["image_pr"].stringValue, seen: false, proPic: i.1["image_pr"].stringValue, loading: false))
               
            }
           
        }
    }
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.title.lowercased().contains(self.search.lowercased())
            }
        }
    }
    func filterDataCategorie(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.type.lowercased().contains(self.categorieplat.lowercased())
            }
        }
    }
    //add to Cart Function
    func addToCar(plat: Plat){
        // checking it is added
        self.items[getIndex(item: plat, isCartIndex: false)].isAdded = !plat.isAdded
        //updating filtered array also for search bar results ...
        self.items[getIndex(item: plat, isCartIndex: false)].isAdded = !plat.isAdded
        
        
        
        if plat.isAdded{
            //removing from list
            self.cartItems.remove(at: getIndex(item: plat, isCartIndex: true))
            return
        }
        //else adding ...
        self.cartItems.append(Cart(plat: plat, quantity: 1))
        
    }
    func getIndex(item : Plat, isCartIndex: Bool)->Int{
        let index = self.items.firstIndex{ (item1)->Bool in
            return item.id == item1.id
            
            
        } ?? 0
        let cartIndex = self.cartItems.firstIndex{ (item1)->Bool in
            return item.id == item1.plat.id
            
            
        } ?? 0
        return isCartIndex ? cartIndex : index
    }
    func calculateTotalPrice()->String{
            
            var price : Float = 0
            
            cartItems.forEach { (item) in
                price += Float(item.quantity) * Float(truncating: item.plat.cost)
            }
            
            return getPrice(value: price)
        }
    func calcultaeTotalPriefordatabse()->Float{
        var price : Float = 0
        
        cartItems.forEach { (item) in
            price += Float(item.quantity) * Float(truncating: item.plat.cost)
        }
        return price
    }
        
        func getPrice(value: Float)->String{
            
            let format = NumberFormatter()
            format.numberStyle = .currency
            
            return format.string(from: NSNumber(value: value)) ?? ""
        }
    func updateOrder(){
        if self.ordered == true{
        self.ordered = false
        }
        else{
            self.ordered = true
        }
    }
    func register(firstName: String,lastname: String,email :String,password: String){
        let data: [String: Any] = ["firstName": firstName,"lastName": lastname ,"email":email ,"password": password]
        
        AF.request(apiurl+"register", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            
            case .success(let value):
                print("Alamo value: \(value)")
                break
            case .failure(let error):
                print("Alamo error: \(error)")
                break
            }
        }
    }
    
    func login(email: String ,password : String)->Int{
        let data: [String: Any] = ["email":email,"password":password]
        var etatString : String
        etatString = ""
        var etat : Int
        etat = 0
        AF.request(apiurl+"login", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { (response) in
            
            self.etatLogin = response.response!.statusCode
            if let httpStatusCode = response.response?.statusCode{
            switch httpStatusCode {
            
            //case .success(let value):
                // print("Alamo value: \(value)")
                
                  
                    case 200:
                        self.loginString = ""
                        self.etatLogin = 200
                    case 202:
                        self.loginString = "le mot de passe est erroné"
                        self.etatLogin = 202
                        
                    default:
                        self.loginString = "Aucun utilisateur est trouvé avec ces informations"
                        self.etatLogin = 400
                    
                
            
            }
            }
        }
        //print(etat )
        print(self.etatLogin)
        return etat
    }

    func loginRestaurant(email: String ,password : String)->Int{
        let data: [String: Any] = ["email":email,"password":password]
        var etatString : String
        etatString = ""
        var etat : Int
        etat = 0
        AF.request(apiurl+"loginrestaurant", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { (response) in
            
           // self.etatLogin = response.response!.statusCode
            if let httpStatusCode = response.response?.statusCode{
            switch httpStatusCode {
                    case 200:
                        print("s7i7 staurant")
                        self.loginString = ""
                        self.etatLogin = 200
                    case 202:
                        print("email ghalet restaurant")
                        self.loginString = "le mot de passe est erroné"
                        self.etatLogin = 202
                        
                    default:
                        print("mech mawjoud")
                        self.loginString = "Aucun utilisateur est trouvé avec ces informations"
                        self.etatLogin = 400
            }
            }
        }
        //print(etat )
        print(self.etatLogin)
        return etat
    }

    
    func forgetPassword(email: String){
        let data: [String: Any] = ["email":email]
        AF.request(apiurl+"forgetpasswordswift", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
           // self.etatLogin = response.response!.statusCode
            if let httpStatusCode = response.response?.statusCode{
            switch httpStatusCode {
                    case 200:
                        let json = try! JSON(data: response.data!)
                        for i in json{
                            print(i.1)
                            self.nouveauemotdepasse = i.1.stringValue
                            print(i.1["x"].stringValue)
                        }
                       // self.nouveauemotdepasse = response.data
                        print(self.nouveauemotdepasse)
                    case 400:
                        print("non")
                       
                        
                    default:
                        print("mech mawjoud")
                        
            }
            }
        }
        
        
    }
    
    func ajouterCommande(idResto: Int,idUser: Int,total :Float,adresse: String){
        let data: [String: Any] = ["idResto": idResto,"idUser": idUser ,"total":total ,"adresse":adresse]
        let parameters: [String: Any] = ["url":"kkk"]
       
        AF.request(apiurl+"add_command", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { response in
            
            if let httpStatusCode = response.response?.statusCode {
                switch(httpStatusCode) {
                case 200:
                    AF.request(self.apiurl+"scan", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                            .responseJSON { response in
                                print("waaaa")
                                print(response)
                            }
                   
                            
                        
                    default:
                        print("waaaaa")
                    }
                
            
            }
        }
    }
    func listerPlat(idResto: Int){
        let data: [String: Any] = ["idResto": idResto]
        let request = AF.request(apiurl+"listproducts")
            // 2
            request.responseJSON { (data) in
              print(data)
            }
    }
    func verifierExistanteFavorisRestaurant(idResto: Int,idUser: Int) {
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser]
        AF.request(apiurl+"verify_existance_favoris", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [self] response in
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            existantetFavoris = true
                        case 202:
                            existantetFavoris = false
                        default:
                            existantetFavoris = false

                        }
                        
                }
            }
        
    }
    func supprimerreservationtable(idResto: Int,idUser: Int) {
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser]
        print("lennnnnnnaaa")
        AF.request(apiurl+"deletetable", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [self] response in
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            print("cest bon suppression")
                        
                        default:
                            print("cest bon suppression")

                        }
                        
                }
            }
        
    }
    func supprimercommande(idResto: Int,idUser: Int) {
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser]
        print("lennnnnnnaaa")
        AF.request(apiurl+"deletecommandeswift", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [self] response in
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            print("cest bon suppression")
                        
                        default:
                            print("cest bon suppression")

                        }
                        
                }
            }
        
    }
    
    
    func ajouterRestaurantAufavorits(idResto: Int,idUser: Int){
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser]
        AF.request(apiurl+"verify_existance_favoris", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            AF.request(self.apiurl+"supprimer_favoris_restaurant", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                .responseJSON { response in
                                    print("waaaa")
                                    print(response)
                                }
                        case 202:
                            AF.request(self.apiurl+"ajouter_favoris_restaurant", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                .responseJSON { response in
                                    print("waaaa")
                                    print(response)
                                }
                            
                        default:
                            print("waaaaa")
                        }
                    }
        }
    }
    func  ajouterRating (idResto: Int,idUser : Int,nbretoiles : Int , nbrfois:Int,somme :Int) {
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser,
            "nbr_etoiles" : nbretoiles,
            "nbr_defois" : nbrfois,
            "somme_rating" : somme
        ]
        AF.request(apiurl+"verify_existance_rating", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 200:
                        print("mawjouda deja")
                        self.ratingString = "Nous avons enregistre votre note"
                        
                    case 202:
                        print("reservinelik")
                        self.ratingString = "Vous avez deja attribué une note"
                        
                    default:
                        print("waaaaa")
                    }
                }
            }
    }
    func verifierFavorisRestaurant(idResto: Int,idUser: Int)->Bool{
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser]
        var message : Bool
        message  = false
        AF.request(apiurl+"verify_existance_favoris", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            message =  true
                        case 202:
                            message = false
                            
                        default:
                            print("waaaaa")
                        }
                    }
        }
        return message
    }
    func  ajouterReservation (idResto: Int,idUser : Int,email : String ) {
        let parameters: [String: Any] = [
            "idResto" : idResto,
            "idUser" : idUser,
            "email" : email
        ]
        AF.request(apiurl+"ajouter_reservation", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 200:
                        print("mawjouda deja")
                        self.resvationString = "Vous avez deja une place . Verifiez votre email"
                        
                    case 202:
                        print("reservinelik")
                        self.resvationString = "On vous a réservé une place. Verifiez votre email"
                        
                    default:
                        print("waaaaa")
                    }
                }
            }
    }
    func  envoyerQRCode (facture: String,email:String ) {
        let parameters: [String: Any] = [
            "facture" : facture,
            "email" : email
        ]
        AF.request(apiurl+"youssefyoussef", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
            }
    }
    func afficherRecents (idClient:String){
        let parameters: [String: Any] = ["idUser" : idClient]
        AF.request(apiurl+"listRecents", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { data in
                let json = try! JSON(data: data.data!)
                for i in json{
                    AF.request(self.apiurl+"listRestaurants/"+i.1["id_resto"].stringValue).responseData{ (data) in
                        
                        let json = try! JSON(data: data.data!)
                        for i in json{
                            print(i.1)
                            self.itemsRestaurants.append(Restaurant(id: i.1["id_resto"].stringValue,name: i.1["nom"].stringValue, price: i.1["adresse"].stringValue, image: i.1["image_pr"].stringValue, rating: i.1["nbr_etoiles"].intValue, description: i.1["description"].stringValue, region: i.1["region"].stringValue, adresse:  i.1["adresse"].stringValue, nbrFois: i.1["nbr_defois"].intValue, sommeRating: i.1["somme_rating"].intValue, imageD: i.1["image_de"].stringValue, imageT: i.1["image_tr"].stringValue))
                            print(i.1["nom"].stringValue)
                        }
                    }
                    
                }
                
            }
    }
    
}
