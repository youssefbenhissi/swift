//
//  CartView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 27/11/2020.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var homeData: PlatViewModel
    // @StateObject var PlatModel = PlatViewModel()
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack{
            HStack(spacing: 20){
                
                Button(action: {present.wrappedValue.dismiss()}) {
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(Color("pink"))
                }
                
                Text("My cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
            if homeData.items.isEmpty{
                Spacer()
                ProgressView()
                Spacer()
            }
            else{
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 0){
                        ForEach(homeData.cartItems)
                        {
                            cart in
                            
                            //cart ItemView
                            HStack(spacing: 15){
                                
                                Image(cart.plat.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(15)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(cart.plat.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    
                                    
                                    
                                    HStack(spacing: 15){
                                        
                                        Text(homeData.getPrice(value: Float(truncating: cart.plat.cost)))
                                            .font(.title2)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                        
                                        Spacer(minLength: 0)
                                        
                                        // Add - Sub Button...
                                        
                                        Button(action: {
                                            if cart.quantity > 1{
                                                homeData.cartItems[homeData.getIndex(item: cart.plat,isCartIndex: true)].quantity -= 1
                                                
                                            }
                                        }) {
                                            
                                            Image(systemName: "minus")
                                                .font(.system(size: 16, weight: .heavy))
                                                .foregroundColor(.black)
                                        }
                                        
                                        Text("\(cart.quantity)")
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                            .background(Color.black.opacity(0.06))
                                        
                                        Button(action: {  homeData.cartItems[homeData.getIndex(item: cart.plat,isCartIndex: true)].quantity += 1}) {
                                            
                                            Image(systemName: "plus")
                                                .font(.system(size: 16, weight: .heavy))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .contextMenu{
                                Button(action: {
                                    //deleting items from cart
                                    // deleting items from cart....
                                    let index = homeData.getIndex(item: cart.plat, isCartIndex: true)
                                    let itemIndex = homeData.getIndex(item: cart.plat, isCartIndex: false)
                                    
                                    let filterIndex = homeData.filtered.firstIndex { (item1) -> Bool in
                                        return cart.plat.id == item1.id
                                    } ?? 0
                                    
                                    homeData.items[itemIndex].isAdded = false
                                    homeData.filtered[filterIndex].isAdded = false
                                    
                                    homeData.cartItems.remove(at: index)
                                }){
                                    Text("remove")
                                }
                            }
                            
                        }
                    }
                }
            }
            // Bottom View...
            
            VStack{
                
                HStack{
                    
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // calculating Total Price...
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top,.horizontal])
                Button(action : {
                    homeData.ajouterCommande(idResto: 1, idUser: 8, total: homeData.calcultaeTotalPriefordatabse(), adresse: homeData.userAddress)
                    
                    
                }){
                    Text("Check out")
                                           .font(.title2)
                                           .fontWeight(.heavy)
                                           .foregroundColor(.white)
                                           .padding(.vertical)
                                           .frame(width: UIScreen.main.bounds.width - 30)
                                           .background(
                                               Color("pink")
                                           )
                                           .cornerRadius(15)
                }
            }
            
            .background(Color.white)
            
        }
        .background(Color("gray").ignoresSafeArea())
    }
}


