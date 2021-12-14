//
//  LandingView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 09/01/2021.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        HomeRestaurant()
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
struct HomeRestaurant: View {
     
     @State var index = 0
     @State var show = false
    @State var isModal: Bool = false
     var body: some View{
         
         ZStack{
             
             // Menu...
             
             HStack{
                 
                 VStack(alignment: .leading, spacing: 12) {
                     
                     Image("avatarland")
                     
                     Text("Hey")
                         .font(.title)
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                         .padding(.top, 10)
                     
                     Text("Catherine")
                         .fontWeight(.bold)
                         .font(.title)
                         .foregroundColor(.white)
                     
                     Button(action: {
                         
                         self.index = 0
                         
                         // animating Views...
                         
                         // Each Time Tab Is Clicked Menu Will be Closed...
                         withAnimation{
                             
                             self.show.toggle()
                         }
                         
                     }) {
                         
                         HStack(spacing: 25){
                             
                             Image("catalougeland")
                                 .foregroundColor(self.index == 0 ? Color("Color1land") : Color.white)
 
                             
                             Text("Catalouge")
                             .foregroundColor(self.index == 0 ? Color("Color1land") : Color.white)
                         }
                         .padding(.vertical, 10)
                         .padding(.horizontal)
                         .background(self.index == 0 ? Color("Color1land").opacity(0.2) : Color.clear)
                         .cornerRadius(10)
                     }
                     .padding(.top,25)
                     
                     Button(action: {
                         
                         self.index = 1
                         
                         withAnimation{
                             
                             self.show.toggle()
                         }
                         
                     }) {
                         
                         HStack(spacing: 25){
                             
                             Image("cartland")
                                 .foregroundColor(self.index == 1 ? Color("Color1land") : Color.white)
 
                             
                             Text("Commandes")
                             .foregroundColor(self.index == 1 ? Color("Color1land") : Color.white)
                         }
                         .padding(.vertical, 10)
                         .padding(.horizontal)
                         .background(self.index == 1 ? Color("Color1land").opacity(0.2) : Color.clear)
                         .cornerRadius(10)
                     }
                     
                    
                     
                     Button(action: {
                         
                         self.index = 3
                         
                         withAnimation{
                             
                             self.show.toggle()
                         }
                         
                     }) {
                         
                         HStack(spacing: 25){
                             
                             Image("ordersland")
                                 .foregroundColor(self.index == 3 ? Color("Color1land") : Color.white)
 
                             
                             Text("Reservations")
                             .foregroundColor(self.index == 3 ? Color("Color1land") : Color.white)
                         }
                         .padding(.vertical, 10)
                         .padding(.horizontal)
                         .background(self.index == 3 ? Color("Color1land").opacity(0.2) : Color.clear)
                         .cornerRadius(10)
                     }
                     
                     Divider()
                         .frame(width: 150, height: 1)
                         .background(Color.white)
                         .padding(.vertical,30)
                     
                     Button(action: {
                        self.isModal = true
                     }) {
                         
                         HStack(spacing: 25){
                             
                             Image("outland")
                                 .foregroundColor(Color.white)
 
                             
                             Text("Se Déconnecter")
                             .foregroundColor(Color.white)
                         }
                         .padding(.vertical, 10)
                         .padding(.horizontal)
                     }.sheet(isPresented: $isModal) {
                        Choice()
                    }
                     
                     Spacer(minLength: 0)
                 }
                 .padding(.top,25)
                 .padding(.horizontal,20)
                 
                 Spacer(minLength: 0)
             }
             .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
             .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
             
             // MainView...
             
             VStack(spacing: 0){
                 
                 HStack(spacing: 15){
                     
                     Button(action: {
                         
                         withAnimation{
                             
                             self.show.toggle()
                         }
                         
                     }) {
                         
                         // close Button...
                         
                         Image(systemName: self.show ? "xmark" : "line.horizontal.3")
                             .resizable()
                             .frame(width: self.show ? 18 : 22, height: 18)
                             .foregroundColor(Color.black.opacity(0.4))
                     }
                     
                     // Changing Name Based On Index...
                     
                     Text(self.index == 0 ? "Home" : (self.index == 1 ? "Cart" : (self.index == 2 ? "Favourites" : "Orders")))
                         .font(.title)
                         .foregroundColor(Color.black.opacity(0.6))
                     
                     Spacer(minLength: 0)
                 }
                 .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                 .padding()
                 
                 GeometryReader{_ in
                     
                     VStack{
                         
                         // Changing Views Based On Index...
                         
                         if self.index == 0{
                             
                             MainPage()
                         }
                         else if self.index == 1{
                             
                            CartRestaurant()
                         }
                         else if self.index == 2{
                             
                             Favourites()
                         }
                         else{
                             
                             Orders()
                         }
                     }
                 }
             }
             .background(Color.white)
             //Applying Corner Radius...
             .cornerRadius(self.show ? 30 : 0)
             // Shrinking And Moving View Right Side When Menu Button Is Clicked...
             .scaleEffect(self.show ? 0.9 : 1)
             .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y: self.show ? 15 : 0)
             // Rotating Slighlty...
             .rotationEffect(.init(degrees: self.show ? -5 : 0))
             
         }
         .background(Color("Colorland").edgesIgnoringSafeArea(.all))
         .edgesIgnoringSafeArea(.all)
     }
 }
 
 // Mainpage View...
 
 struct MainPage : View {
    @StateObject var PlatModel = PlatViewModel()
    @ObservedObject var obs = observerStatistiques(idResto: 1)
    @ObservedObject var obsPlats = observerStatistiquesPlats(idResto: 1)
    @ObservedObject var obsCommandes = observerStatistiquesCommandes(idResto: 1)
    @State var selected = 0
        var colors = [Color("Color1stat"),Color("Colorstat")]
        var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
        
        var body: some View{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Daily Workout in Hrs")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 15){
                            
                            ForEach(workout_Data){work in
                                
                                // Bars...
                                
                                VStack{
                                    
                                    VStack{
                                        
                                        Spacer(minLength: 0)
                                        
                                        if selected == work.id{
                                            
                                            Text(getHrs(value: work.workout_In_Min))
                                                .foregroundColor(Color("Colorstat"))
                                                .padding(.bottom,5)
                                        }
                                        
                                        RoundedShapeStat()
                                            .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : [Color.white.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                        // max height = 200
                                            .frame(height: getHeight(value: work.workout_In_Min))
                                    }
                                    .frame(height: 220)
                                    .onTapGesture {
                                        
                                        withAnimation(.easeOut){
                                            
                                            selected = work.id
                                        }
                                    }
                                    
                                    Text(work.day)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(10)
                    .padding()
                    
                    HStack{
                        
                        Text("Statistics")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer(minLength: 0)
                    }
                    .padding()
                    
                    // stats Grid....
                    
                    LazyVGrid(columns: columns,spacing: 30){
                        
                        ForEach(obsCommandes.datas){stat in
                            
                            VStack(spacing: 32){
                                
                                HStack{
                                    
                                    Text(stat.title)
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                // Ring...
                                
                                ZStack{
                                    
                                    Circle()
                                        .trim(from: 0, to: 1)
                                        .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Circle()
                                        .trim(from: 0, to: (stat.currentData / stat.goal))
                                        .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Text(getPercent(current: stat.currentData, Goal: stat.goal) + " %")
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(stat.color)
                                        .rotationEffect(.init(degrees: 90))
                                }
                                .rotationEffect(.init(degrees: -90))
                                
                                Text(getDec(val: stat.currentData) + " " + getType(val: stat.title))
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        }
                       /* ForEach(obsPlats.datas){stat in
                            
                            VStack(spacing: 32){
                                
                                HStack{
                                    
                                    Text(stat.title)
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                // Ring...
                                
                                ZStack{
                                    
                                    Circle()
                                        .trim(from: 0, to: 1)
                                        .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Circle()
                                        .trim(from: 0, to: (stat.currentData / stat.goal))
                                        .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Text(getPercent(current: stat.currentData, Goal: stat.goal) + " %")
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(stat.color)
                                        .rotationEffect(.init(degrees: 90))
                                }
                                .rotationEffect(.init(degrees: -90))
                                
                                Text(getDec(val: stat.currentData) + " " + getType(val: stat.title))
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        }*/
                       /* ForEach(obsCommandes.datas){stat in
                            
                            VStack(spacing: 32){
                                
                                HStack{
                                    
                                    Text(stat.title)
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                // Ring...
                                
                                ZStack{
                                    
                                    Circle()
                                        .trim(from: 0, to: 1)
                                        .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Circle()
                                        .trim(from: 0, to: (stat.currentData / stat.goal))
                                        .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                    
                                    Text(getPercent(current: stat.currentData, Goal: stat.goal) + " %")
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(stat.color)
                                        .rotationEffect(.init(degrees: 90))
                                }
                                .rotationEffect(.init(degrees: -90))
                                
                                Text(getDec(val: stat.currentData) + " " + getType(val: stat.title))
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        }*/
                    }
                    .padding()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
            // status bar color is not changing
            // its still in beta...
        }
        
        // calculating Type...
        
        func getType(val: String)->String{
            
            switch val {
            case "Water": return "L"
            case "Sleep": return "Hrs"
            case "Running": return "Km"
            case "Cycling": return "Km"
            case "Steps": return "stp"
            default: return "Kcal"
            }
        }
        
        // converting Number to decimal...
        
        func getDec(val: CGFloat)->String{
            
            let format = NumberFormatter()
            format.numberStyle = .decimal
            
            return format.string(from: NSNumber.init(value: Float(val)))!
        }
        
        // calculating percent...
        
        func getPercent(current : CGFloat,Goal : CGFloat)->String{
            
            let per = (current / Goal) * 100
            
            return String(format: "%.1f", per)
        }
        
        // calculating Hrs For Height...
        
        func getHeight(value : CGFloat)->CGFloat{
            
            // the value in minutes....
            // 24 hrs in min = 1440
            
            let hrs = CGFloat(value / 1440) * 200
            
            return hrs
        }
        
        // getting hrs...
        
        func getHrs(value: CGFloat)->String{
            
            let hrs = value / 60
            
            return String(format: "%.1f", hrs)
        }
 }
 
struct RoundedShapeStat : Shape {
      
      func path(in rect: CGRect) -> Path {
          
  
          let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
          
          return Path(path.cgPath)
      }
  }
  
  // sample Data...
  
  struct Daily : Identifiable {
      
      var id : Int
      var day : String
      var workout_In_Min : CGFloat
  }
  
  var workout_Data = [
  
      Daily(id: 0, day: "Day 1", workout_In_Min: 480),
      Daily(id: 1, day: "Day 2", workout_In_Min: 880),
      Daily(id: 2, day: "Day 3", workout_In_Min: 250),
      Daily(id: 3, day: "Day 4", workout_In_Min: 360),
      Daily(id: 4, day: "Day 5", workout_In_Min: 1220),
      Daily(id: 5, day: "Day 6", workout_In_Min: 750),
      Daily(id: 6, day: "Day 7", workout_In_Min: 950)
  ]
  
  // stats Data...
  
  struct Stats : Identifiable {
      
      var id : Int
      var title : String
      var currentData : CGFloat
      var goal : CGFloat
      var color : Color
  }
  
  var stats_Data = [
  
      Stats(id: 0, title: "Running", currentData: 6.8, goal: 15, color: Color("runningstat")),
      
      Stats(id: 1, title: "Water", currentData: 4, goal: 5, color: Color("waterstat")),
      
      Stats(id: 2, title: "Energy Burn", currentData: 585, goal: 1000, color: Color("energystat")),
      
      Stats(id: 3, title: "Sleep", currentData: 6.2, goal: 10, color: Color("sleepstat")),
      
      Stats(id: 4, title: "Cycling", currentData: 12.5, goal: 25, color: Color("cyclestat")),
      
      Stats(id: 5, title: "Steps", currentData: 16889, goal: 20000, color: Color("stepsstat")),
  ]

 // All Other Views...
 
 struct CartRestaurant : View {
    @StateObject var PlatModel = PlatViewModel()
    @ObservedObject var obs = observerReservation(idResto: 1)
    @State var messages : [commandeback] = [
        
        //Message(id: 0, name: "Catherine", message: "hellooooooo", profile: "p1", offset: 0),
        //Message(id: 1, name: "Emma", message: "New Video !!!", profile: "p2", offset: 0),
        //Message(id: 2, name: "Julie", message: "How Are You ???", profile: "p3", offset: 0),
        //Message(id: 3, name: "Emily", message: "Hey iJustine", profile: "p4", offset: 0),
        //Message(id: 4, name: "Kaviya", message: "hello ????", profile: "p5", offset: 0),
        //Message(id: 5, name: "Jenna", message: "Bye :)))", profile: "p6", offset: 0),
        
    ]
    
    @State var pinnedViews : [commandeback] = []
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    @Namespace var name
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            // Pinned View...
            
            if !pinnedViews.isEmpty{
                
                LazyVGrid(columns: columns,spacing: 20){
                    
                    ForEach(pinnedViews){pinned in
                        
                        Image(pinned.profile)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            //padding 30 + spacing 20 = 70
                            .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: (UIScreen.main.bounds.width - 70) / 3)
                            .clipShape(Circle())
                        // context menu for restoring...
                            // context menushape...
                            .contentShape(Circle())
                            .contextMenu{
                                
                                Button(action: {
                                    
                                    // removing View...
                                    
                                    withAnimation(.default){
                                        
                                        var index = 0
                                        
                                        for i in 0..<pinnedViews.count{
                                            
                                            if pinned.profile == pinnedViews[i].profile{
                                                
                                                index = i
                                            }
                                        }
                                        
                                        // removing pin view...
                                        
                                        pinnedViews.remove(at: index)
                                        
                                        // adding view to main View....
                                        
                                        obs.datas.append(pinned)
                                    }
                                    
                                }) {
                                    
                                    Text("Remove")
                                }
                            }
                            //.matchedGeometryEffect(id: pinned.profile, in: name)
                    }
                }
                .padding()
            }
            
            LazyVStack(alignment: .leading, spacing: 0, content: {
                
                ForEach(obs.datas) { msg in
                    
                    ZStack {
                        
                        // adding Buttons...
                        
                        HStack{
                            
                            Color.yellow
                                .frame(width: 90)
                            // hiding when left swipe...
                                .opacity(msg.offset > 0 ? 1 : 0)
                            
                            Spacer()
                            
                            Color.red
                                .frame(width: 90)
                                .opacity(msg.offset < 0 ? 1 : 0)
                        }
                        
                        HStack{
                            
                            Button(action: {
                                
                                // appending View....
                                withAnimation(.default){
                                    
                                    
                                    let index = getIndex(profile: msg.profile)
                                    
                                    var pinnedView = obs.datas[index]
                                    
                                    // setting offset to 0
                                    
                                    pinnedView.offset = 0
                                    
                                    pinnedViews.append(pinnedView)
                                    
                                    // removing from main View...
                                    
                                    obs.datas.removeAll { (msg1) -> Bool in
                                        
                                        if msg.profile == msg1.profile{return true}
                                        else{return false}
                                    }
                                }
                                
                            }, label: {
                                
                                Image(systemName: "pin.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            })
                            .frame(width: 90)
                            
                            // on ended not working...
                            
                            Spacer()
                            
                            Button(action: {
                                
                                // removing from main View...
                                
                                withAnimation(.default){
                                    
                                    obs.datas.removeAll { (msg1) -> Bool in
                                        
                                        if msg.profile == msg1.profile{return true}
                                        else{return false}
                                    }
                                }
                                PlatModel.supprimercommande(idResto: 1, idUser: 8)
                                
                            }, label: {
                                
                                Image(systemName: "trash.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            })
                            .frame(width: 90)
                        }
                        
                        HStack(spacing: 15){
                            
                            Image(msg.profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .matchedGeometryEffect(id: msg.profile, in: name)
                            
                            VStack(alignment: .leading,spacing: 10){
                                
                                Text(msg.name)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Text(msg.message)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                
                                Divider()
                            }
                        }
                        .padding(.all)
                        .background(Color.white)
                        .contentShape(Rectangle())
                        // adding gesture...
                        .offset(x: msg.offset)
                        .gesture(DragGesture().onChanged({ (value) in
                            
                            withAnimation(.default){
                                
                                obs.datas[getIndex(profile: msg.profile)].offset = value.translation.width
                            }
                            
                        })
                        .onEnded({ (value) in
                            
                            withAnimation(.default){
                                
                                if value.translation.width > 80{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = 90
                                }
                                else if value.translation.width < -80{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = -90
                                }
                                else{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = 0
                                }
                            }
                        }))
                        
                    }
                }
            })
            .padding(.vertical)
        })
    }
    
    func getIndex(profile: String)->Int{
        
        var index = 0
        
        for i in 0..<obs.datas.count{
            
            if profile == obs.datas[i].profile{
                
                index = i
            }
        }
        
        return index
    }
 }
 
 struct Orders : View {
    @StateObject var PlatModel = PlatViewModel()
    @ObservedObject var obs = observerCommandes(idResto: 1)
    @State var messages : [Message] = [
        
        Message(id: 0, name: "Catherine", message: "hellooooooo", profile: "p1", offset: 0),
        Message(id: 1, name: "Emma", message: "New Video !!!", profile: "p2", offset: 0),
        Message(id: 2, name: "Julie", message: "How Are You ???", profile: "p3", offset: 0),
        Message(id: 3, name: "Emily", message: "Hey iJustine", profile: "p4", offset: 0),
        Message(id: 4, name: "Kaviya", message: "hello ????", profile: "p5", offset: 0),
        Message(id: 5, name: "Jenna", message: "Bye :)))", profile: "p6", offset: 0),
        Message(id: 6, name: "Juliana", message: "Nothing Much......", profile: "p7", offset: 0),
    ]
    
    @State var pinnedViews : [Message] = []
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    @Namespace var name
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            // Pinned View...
            
            if !pinnedViews.isEmpty{
                
                LazyVGrid(columns: columns,spacing: 20){
                    
                    ForEach(pinnedViews){pinned in
                        
                        Image(pinned.profile)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            //padding 30 + spacing 20 = 70
                            .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: (UIScreen.main.bounds.width - 70) / 3)
                            .clipShape(Circle())
                        // context menu for restoring...
                            // context menushape...
                            .contentShape(Circle())
                            .contextMenu{
                                
                                Button(action: {
                                   
                                    // removing View...
                                    
                                    withAnimation(.default){
                                        
                                        var index = 0
                                        
                                        for i in 0..<pinnedViews.count{
                                            
                                            if pinned.profile == pinnedViews[i].profile{
                                                
                                                index = i
                                            }
                                        }
                                        
                                        // removing pin view...
                                        
                                        pinnedViews.remove(at: index)
                                        
                                        // adding view to main View....
                                        
                                        obs.datas.append(pinned)
                                    }
                                    //PlatModel.ajouterRestaurantAufavorits(idResto: Int(rest.id)!, idUser: 8)
                                    
                                }) {
                                    
                                    Text("Remove")
                                }
                            }
                            //.matchedGeometryEffect(id: pinned.profile, in: name)
                    }
                }
                .padding()
            }
            
            LazyVStack(alignment: .leading, spacing: 0, content: {
                
                ForEach(obs.datas) { msg in
                    
                    ZStack {
                        
                        // adding Buttons...
                        
                        HStack{
                            
                            Color.yellow
                                .frame(width: 90)
                            // hiding when left swipe...
                                .opacity(msg.offset > 0 ? 1 : 0)
                            
                            Spacer()
                            
                            Color.red
                                .frame(width: 90)
                                .opacity(msg.offset < 0 ? 1 : 0)
                        }
                        
                        HStack{
                            
                            Button(action: {
                                
                                // appending View....
                                withAnimation(.default){
                                    
                                    
                                    let index = getIndex(profile: msg.profile)
                                    
                                    var pinnedView = obs.datas[index]
                                    
                                    // setting offset to 0
                                    
                                    pinnedView.offset = 0
                                    
                                    pinnedViews.append(pinnedView)
                                    
                                    // removing from main View...
                                    
                                    obs.datas.removeAll { (msg1) -> Bool in
                                        
                                        if msg.profile == msg1.profile{return true}
                                        else{return false}
                                    }
                                }
                                
                            }, label: {
                                
                                Image(systemName: "pin.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            })
                            .frame(width: 90)
                            
                            // on ended not working...
                            
                            Spacer()
                            
                            Button(action: {
                                
                                // removing from main View...
                                
                                withAnimation(.default){
                                    
                                    obs.datas.removeAll { (msg1) -> Bool in
                                        
                                        if msg.profile == msg1.profile{return true}
                                        else{return false}
                                    }
                                }
                                PlatModel.supprimerreservationtable(idResto: 1, idUser: 8)
                                
                            }, label: {
                                
                                Image(systemName: "trash.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            })
                            .frame(width: 90)
                        }
                        
                        HStack(spacing: 15){
                            
                            Image(msg.profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .matchedGeometryEffect(id: msg.profile, in: name)
                            
                            VStack(alignment: .leading,spacing: 10){
                                
                                Text(msg.name)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Text(msg.message)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                
                                Divider()
                            }
                        }
                        .padding(.all)
                        .background(Color.white)
                        .contentShape(Rectangle())
                        // adding gesture...
                        .offset(x: msg.offset)
                        .gesture(DragGesture().onChanged({ (value) in
                            
                            withAnimation(.default){
                                
                                obs.datas[getIndex(profile: msg.profile)].offset = value.translation.width
                            }
                            
                        })
                        .onEnded({ (value) in
                            
                            withAnimation(.default){
                                
                                if value.translation.width > 80{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = 90
                                }
                                else if value.translation.width < -80{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = -90
                                }
                                else{
                                    
                                    obs.datas[getIndex(profile: msg.profile)].offset = 0
                                }
                            }
                        }))
                        
                    }
                }
            })
            .padding(.vertical)
        })
    }
    
    func getIndex(profile: String)->Int{
        
        var index = 0
        
        for i in 0..<obs.datas.count{
            
            if profile == obs.datas[i].profile{
                
                index = i
            }
        }
        
        return index
    }
 }

// Sample Data...

struct Message : Identifiable {
    
    var id : Int
    var name : String
    var message : String
    var profile : String
    var offset: CGFloat
}

struct commandeback : Identifiable {
    
    var id : Int
    var name : String
    var message : String
    var messageadresse : String
    var profile : String
    var offset: CGFloat
}
 
 struct Favourites : View {
     
     var body: some View{
         
         VStack{
             
            Image("p1").frame(width: 150, height: 150)
         }
     }
 }
