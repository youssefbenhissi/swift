//
//  ListRestaurants.swift
//  mini projet sim
//
//  Created by youssef benhissi on 08/12/2020.
//

import SwiftUI

import SDWebImageSwiftUI

struct ListRestaurants: View {
    @StateObject var PlatModel = PlatViewModel()
    @StateObject var homeModel = CarouselViewModel()
    @ObservedObject var obs = observer()
    var white = Color.white.opacity(0.85)
    var body: some View {
        VStack{
           
                   ZStack{
                       
                       HStack{
                           Button(action: {}) {
                               
                               Image(systemName: "rectangle.grid.2x2")
                                   .font(.title2)
                                   .foregroundColor(white)
                           }
                           
                           Spacer()
                           
                           Button(action: {
                           
                           }) {
                               
                               Image(systemName: "magnifyingglass")
                                   .font(.title2)
                                   .foregroundColor(white)
                           }
                       }
                       
                       Text("Salads")
                           .font(.title)
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                   }
                   .padding([.horizontal,.bottom])
                   .padding(.top,10)
                   
                   ScrollView(.vertical, showsIndicators: false) {
                       
                       VStack{
                        Text("Récents restaurants")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("txt"))
                        Spacer()
                        
                      /*  ForEach(PlatModel.itemsRestaurants){
                            plat in
                           HStack{
                               
                               VStack(alignment: .leading, spacing: 6) {
                               

                                   
                                Text(plat.name)
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                                   
                                   
                                Text(plat.price)
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                                    
                               }
                               
                               Spacer(minLength: 5)
                               
                            AnimatedImage(url: URL(string: plat.image)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                           }
                           .padding([.vertical,.leading])
                           .background(
                           
                               LinearGradient(gradient: .init(colors: [Color("g1"),Color("g2")]), startPoint: .top, endPoint: .bottom)
                                   .cornerRadius(25)
                                   .padding(.vertical,5)
                                   .padding(.trailing,30)
                           )
                           .padding(.horizontal)
                         
                        }*/
                        restaurantsdujour()
                            .environmentObject(homeModel)
                        Text("Tous nos restaurants")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("txt"))
                        Spacer()
                        
                           ScrollView(.horizontal, showsIndicators: false) {
                               
                               HStack(spacing: 25){
                                   
                                ForEach(obs.datas){item in
                                       
                                       // Card View....
                                    
                                    
                                    RestaurantItemW(item: item)
                                   }
                               }
                               .padding()
                               .padding(.horizontal,4)
                           }
                           
                          /*
                           
                           HStack{
                               
                               Image("p4")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 170, height: 170)
                                   .padding(.trailing)
                               
                               VStack(alignment: .leading, spacing: 6) {
                                   
                                   Text("Fruit Salad")
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
           
                                   Text("@Awesome Price")
                                       .foregroundColor(white)
                                   
                                   Text("$10.82")
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                               }
                               
                               Spacer(minLength: 5)
                           }
                           .padding([.vertical,.trailing])
                           .background(
                           
                               LinearGradient(gradient: .init(colors: [Color("g1"),Color("g2")]), startPoint: .top, endPoint: .bottom)
                                   .cornerRadius(25)
                                   .padding(.vertical,25)
                                   .padding(.leading,30)
                           )
                           .padding(.horizontal)*/
                       }
                       .padding(.bottom,100)
                   }
               }
    }
}

struct ListRestaurants_Previews: PreviewProvider {
    static var previews: some View {
        ListRestaurants()
    }
}
