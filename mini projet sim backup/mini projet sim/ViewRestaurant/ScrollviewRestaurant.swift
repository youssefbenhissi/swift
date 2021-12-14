//
//  ScrollviewRestaurant.swift
//  mini projet sim
//
//  Created by youssef benhissi on 09/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScrollviewRestaurant: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct scroll : View{
    
    @State var search = ""
        @State var index = 0
    @StateObject var PlatModel = PlatViewModel()
        @State var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    @ObservedObject var obs = observer()
    //@StateObject var PlatModel = PlatViewModel()
        var body: some View{

            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack{
                    
                    HStack{
                        
                        Text("nos Restaurants")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    TextField("Search", text: self.$search)
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.07))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top,25)
                    
                    // Carousel List...
                    
                    TabView(selection: self.$index){
                        
                        ForEach(0...5,id: \.self){index in
                            
                            Image("p\(index)")
                                .resizable()
                                // adding animation...
                                .frame(height: self.index == index ?  230 : 180)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                // for identifying current index....
                                .tag(index)
                        }
                    }
                    .frame(height: 230)
                    .padding(.top,25)
                    .tabViewStyle(PageTabViewStyle())
                    .animation(.easeOut)
                    
                    // adding custom Grid....
                    
                    HStack{
                        
                        Text("Popular")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            
                            // reducing to row.....
                            
                            withAnimation(.easeOut){
                                
                                if self.columns.count == 2{
                                    
                                    self.columns.removeLast()
                                }
                                else{
                                    
                                    self.columns.append(GridItem(.flexible(), spacing: 15))
                                }
                            }
                            
                        } label: {
                        
                            Image(systemName: self.columns.count == 2 ? "rectangle.grid.1x2" : "square.grid.2x2")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }

                    }
                    .padding(.horizontal)
                    .padding(.top,25)
                    
                    LazyVGrid(columns: self.columns,spacing: 25){
                        
                        ForEach(obs.datas){game in
                            
                            // GridView....
                            
                            GridView(rest: game, etatFavoris: PlatModel.verifierFavorisRestaurant(idResto: Int(game.id)!, idUser: 8) , columns: self.$columns)
                        }
                    }
                    .padding([.horizontal,.top])
                    
                }
                .padding(.vertical)
            }
            .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
        }
    
}
struct GridView : View {

    @State var rest : Restaurant
    @State var etatFavoris : Bool
    @Binding var columns : [GridItem]
    @Namespace var namespace
    @StateObject var PlatModel = PlatViewModel()
    @State var isModal: Bool = false
    var body: some View{
        

        VStack{
            
            if self.columns.count == 2{
                	
                VStack(spacing: 15){
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                        
                        //AnimatedImage(url: URL(string: rest.image)!)
                        Image(rest.name)
                            .resizable()
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        Button {
                            PlatModel.ajouterRestaurantAufavorits(idResto: Int(rest.id)!, idUser: 8)
                            etatFavoris.toggle()
                        } label: {
                        
                            Image(systemName: self.etatFavoris == true ? "suit.heart.fill" : "suit.heart")
                                .foregroundColor(.red)
                                .padding(.all,10)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.all,10)

                    }
                    .matchedGeometryEffect(id: "image", in: self.namespace)
                    
                    Text(rest.name)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "title", in: self.namespace)
                    HStack
                    {
                        Button {
                            self.isModal = true
                        } label: {
                        
                            Text("Decouvrir le menu")
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                                .padding(.horizontal,25)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .matchedGeometryEffect(id: "buy", in: self.namespace)
                        .sheet(isPresented: $isModal) {
                            HomeCli()
                        }
                    }
                    

                }
            }
            else{
                
                // Row View....
                
                // adding animation...
                
                HStack(spacing: 15){
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                        
                        Image(rest.name)
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width - 45) / 2,height: 250)
                            .cornerRadius(15)
                        
                        Button {
                            PlatModel.ajouterRestaurantAufavorits(idResto: Int(rest.id)!, idUser: 8)
                            etatFavoris.toggle()
                        } label: {
                        
                            Image(systemName: self.etatFavoris == true ? "suit.heart.fill" : "suit.heart")
                                .foregroundColor(.red)
                                .padding(.all,10)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.all,10)

                    }
                    .matchedGeometryEffect(id: "image", in: self.namespace)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(rest.name)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "title", in: self.namespace)
                        
                        // Rating Bar...
                        
                        HStack(spacing: 10){
                            
                            ForEach(1...5,id: \.self){rating in
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(self.rest.rating >= rating ? .yellow : .gray)
                            }
                            
                            Spacer(minLength: 0)
                        }
                        
                        Button {
                            self.isModal = true
                        } label: {
                        
                            Text("Reserver Une place")
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                                .padding(.horizontal,25)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.top,10)
                        .matchedGeometryEffect(id: "buy", in: self.namespace)
                        .sheet(isPresented: $isModal) {
                            Detail(selected: $rest, show: $isModal)
                        }
                    }
                }
                .padding(.trailing)
                .background(Color.white)
                .cornerRadius(15)
            }
        }
    }
}
struct Game : Identifiable {
    
    var id : Int
    var name : String
    var image : String
    var rating : Int
}

var dataRest = [

    Restaurant

]()
struct ScrollviewRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        ScrollviewRestaurant()
    }
}
