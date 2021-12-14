//
//  Choix.swift
//  mini projet sim
//
//  Created by youssef benhissi on 28/11/2020.
//

import SwiftUI

import SDWebImageSwiftUI
struct Choix: View {
    var body: some View {
        Choice()
    }
    
}
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
struct Choice : View {
    @StateObject var PlatModel = PlatViewModel()
    @State var show = false
    @State var isModal: Bool = false
    @State var isModalRestaurant: Bool = false
    @State var current : Post!
    @State var dataStories = [
      
              Post(id: 0, name: "iJustine", url: "shake1", seen: false, proPic: "img1", loading: false),
              Post(id: 1, name: "Emily", url: "p2", seen: false, proPic: "img2", loading: false),
              Post(id: 2, name: "Juliana", url: "p3", seen: false, proPic: "img3", loading: false),
              Post(id: 3, name: "Emma", url: "p4", seen: false, proPic: "img4", loading: false),
              Post(id: 4, name: "Catherine", url: "p5", seen: false, proPic: "img5", loading: false)
          ]
    var body: some View{
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                HStack{
                    Text("Discover a \nDifferent World")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color("txt"))
                    Spacer(minLength: 0)
                    
                
                }
                .padding()
                
                //since all edged are ignored
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                ZStack{
                    VStack{
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 15){
                                ForEach(PlatModel.itemsPosts){
                                    i in
                                    
                                    VStack(spacing: 8){
                                        ZStack{
                                            
                                            AnimatedImage(url: URL(string: i.url)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 65, height: 65)
                                                .clipShape(Circle())
                                            if !i.seen{
                                                Circle()
                                                    .trim(from: 0, to: 1)
                                                    .stroke(AngularGradient(gradient: .init(colors: [.red,.orange,.red]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [i.loading ? 7 : 0]))
                                                    .frame(width: 74, height: 74)
                                                    .rotationEffect(.init(degrees: i.loading ? 360 : 0))
                                            }
                                            
                                            
                                        }
                                        Text(i.name)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 75)
                                    .onTapGesture{
                                        withAnimation(Animation.default.speed(0.35).repeatForever(autoreverses: false)){
                                            i.loading.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + (i.seen ? 0 : 1.2)){
                                                current = i
                                                withAnimation(.default){
                                                    self.show.toggle()
                                                }
                                                
                                                i.loading = false
                                                i.seen = true
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom)
                        }
                    }
                    if self.show{
                        ZStack{
                            Color.black.edgesIgnoringSafeArea(.all)
                            ZStack(alignment: .topTrailing){
                                GeometryReader{_ in
                                    VStack{
                                        AnimatedImage(url: URL(string: self.current.url)!)
                                            .resizable()
                                            .frame(width: UIScreen.screenWidth, height: 130)
                                            //.aspectRatio(contentMode: .fit)
                                            
                                        Image(self.current.url)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                                VStack(spacing: 15){
                                    Loader(show: self.$show)
                                    /*HStack(spacing: 15){
                                        AnimatedImage(url: URL(string: self.current.proPic)!)
                                            .resizable()
                                            .frame(width: 55,height: 55)
                                            .clipShape(Circle())
                                        Spacer()
                                    }*/
                                    .padding(.leading)
                                }
                                .padding(.top)
                            }
                        }
                        .transition(.move(edge: .trailing))
                        .onTapGesture{
                            
                            self.show.toggle()
                        }
                        
                    }
                }
                
                HStack{
                    Text("Espaces")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("txt"))
                    Spacer()
                    
                }
                .padding()
                /*
                Button(action: {
                    self.isModal = true
                        }) {
                            Image(systemName: "arrow.right")
                                .padding(20)
                                .background(Color(.white))
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        
                        }.sheet(isPresented: $isModal) {
                            Choice()
                        }*/
                Button(action: {
                    self.isModal = true
                        }) {
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                        Image("clientc")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(25)
                        VStack(alignment: .trailing , spacing: 8){
                            Text("Espace Client")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                           
                        }
                        .padding()
                    }.padding()
                }.sheet(isPresented: $isModal) {
                    LoginAndSign()
                }
                
                Button(action: {
                    self.isModalRestaurant = true
                        }) {
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                        Image("restaurantc")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(25)
                        VStack(alignment: .trailing , spacing: 8){
                            Text("Espace Restaurant")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                    }.padding()
                }.sheet(isPresented: $isModalRestaurant) {
                    LoginSignUpRestaurant()
                }
                    
                
                
            }
        }
    }
}
// Model And Sample Data...

struct Loader : View {
      
      @State var width : CGFloat = 100
      @Binding var show : Bool
      var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
      @State var secs : CGFloat = 0
      
      var body : some View{
          
          ZStack(alignment: .leading){
              
              Rectangle()
                  .fill(Color.white.opacity(0.6))
                  .frame(height: 3)
              
              Rectangle()
                  .fill(Color.white)
                  .frame(width: self.width, height: 3)
          }
          .onReceive(self.time) { (_) in
              
              self.secs += 0.1
              
              if self.secs <= 6{//6 seconds.....
                  
                  let screenWidth = UIScreen.main.bounds.width
                  
                  self.width = screenWidth * (self.secs / 6)
              }
              else{
                  
                  self.show = false
              }
  
          }
      }
  }
  

struct Model : Identifiable {
    
    var id = UUID().uuidString
    var title : String
    var country : String
    var ratings : String
    var price : String
    var img : String
}

var data = [

    Model(title: "Carribean", country: "French", ratings: "4.9", price: "$200", img: "client"),
    Model(title: "Big Sur", country: "USA", ratings: "4.1", price: "$150", img: "restaurant"),
]
class Post: Identifiable {
     
    var id : Int = 0
    var name : String = ""
    var url : String = ""
     var seen : Bool
    var proPic : String = ""
     var loading : Bool
    init(id: Int, name: String, url: String, seen: Bool, proPic: String, loading: Bool) {
        self.id = id
        self.name = name
        self.url = url
        self.seen = seen
        self.proPic = proPic
        self.loading = loading
    }
 }


struct Choix_Previews: PreviewProvider {
    static var previews: some View {
        Choix()
    }
}
