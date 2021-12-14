//
//  PlatView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 24/11/2020.
//

import SwiftUI
//import GoogleMobileAds
struct PlatView: View {
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
struct PlatV : View {
    @StateObject var PlatModel = PlatViewModel()
    @State var midY : CGFloat = 0
    @State var selected = "Shakes"
    @State var isModal: Bool = false
    @StateObject var HomeModel = PlatViewModel()
    var body: some View{
        
        HStack(spacing: 0){
            
            VStack{
                Button(action: {}, label: {
                    
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                })
                
                Spacer(minLength: 0)
                
                ForEach(tabs,id: \.self){name in
                    
                    ZStack {
                        
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 13, height: 13)
                            .offset(x: selected == name ? 28 : -80)
                        
                        Color("tab")
                            .frame(width: 150, height: 110)
                            .rotationEffect(.init(degrees: -90))
                            .offset(x: -50)
                        
                        GeometryReader {reader in
                            
                            Button(action: {
                                
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.65, blendDuration: 0.65)){
                                    
                                    self.midY = reader.frame(in: .global).midY
                                    self.selected = name
                                    PlatModel.categorieplat = self.selected
                                    PlatModel.filterDataCategorie()

                                }
                                                                
                            }, label: {
                                
                                Text(name)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                            })
                            .frame(width: 150, height: 110)
                            // default frame...
                            .rotationEffect(.init(degrees: -90))
                            
                            // getting Inital First Curve Position....
                            .onAppear(perform: {
                                
                                if name == tabs.first{
                                    self.midY = reader.frame(in: .global).midY
                                    PlatModel.categorieplat = name
                                    PlatModel.filterDataCategorie()

                                }
                            })
                            .offset(x: -8)
                        }
                        .frame(width: 150, height: 110)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .frame(width: 70)
            .background(
                Color("tab")
                    .clipShape(Curve(midY: midY))
                    .ignoresSafeArea()
                
            )
            
            VStack(spacing: 10){
                
//                AdView().frame( height: 50)
                HStack{
                    Text(PlatModel.userLoction == nil ? "Localisation ..." : "livré à")
                        .foregroundColor(.black)
                    Text(PlatModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("pink"))
                    Spacer(minLength: 0)
                    
                    
                    
                    Button(action: {
                     self.isModal = true
                                                      
                    }, label: {
                        
                        Image(systemName: "cart")
                            .foregroundColor(.black)
                            .padding(10)
            
                            .clipShape(Circle())
                    })
                     .sheet(isPresented: $isModal, content: {
                         CartView(homeData: PlatModel)
                     })
                    
                    
                    
                   /* Button("Panier") {
                               self.isModal = true
                           }.sheet(isPresented: $isModal, content: {
                               CartView(homeData: PlatModel)
                           })
                    */
                    
                       
                        
                    
                }
                .padding()
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 4, content: {
                        
                        Text("Smoothie King")
                            .font(.title)
                            .fontWeight(.heavy)
                        
                        Text("Shakes")
                            .font(.title)
                    })
                    .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 15){
                    
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search", text: $PlatModel.search)
                    
                    
                }
                .padding(.horizontal)
                .padding(.vertical,10)
                .background(Color.black.opacity(0.06))
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.top)
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    LazyVStack(spacing: 25){
                        
                        // Items....
                        ForEach(PlatModel.filtered){
                            plat in
                            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center), content: {
                                
                                VStack{
                                    
                                    HStack{
                                        
                                        VStack(alignment: .leading, spacing: 4, content: {
                                            
                                            Text(plat.title)
                                                .fontWeight(.heavy)
                                            
                                            Text(plat.cost.stringValue)
                                                .fontWeight(.heavy)
                                        })
                                        .foregroundColor(.white)
                                        
                                        Spacer(minLength: 0)
                                        
                                        Button(action: {
                                             PlatModel.addToCar(plat: plat)
                                        }, label: {
                                            
                                            Image(systemName: plat.isAdded ?  "checkmark" : "plus")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(plat.isAdded ? Color.green : Color.pink)
                                                .clipShape(Circle())
                                        })
                                    }
                                    .padding([.horizontal,.top])
                                    .padding(.bottom,-15)
                                    /*
                                     AnimatedImage(url: URL(string: plat.image)!)
                                         .resizable()
                                         .aspectRatio(contentMode: .fit)
                                         .frame(width: 50, height: 50)
                                         .offset(x: -30)
                                     */
                                    Image(plat.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 170, height: 229)
                                        .offset(x: -30)
                                }
                                // Both Image ANd COlor name are same....
                                .background(
                                    Color("shake1")
                                        .cornerRadius(35)
                                        .clipShape(ItemCurve())
                                        .padding(.bottom,35)
                                )
                                
                                Button(action: {
                                            Sandwich()
                                                                  
                                }, label: {
                                    
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color("shake1"))
                                        .clipShape(Circle())
                                })
                                .offset(y: -18)
                            })
                        }
                    }
                    .padding()
                    .padding(.top)
                })
            }
            .padding(.leading)
            if PlatModel.noLocation{
                Text("Please enable Access In settings for further Move On")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear(perform: {
            PlatModel.locationManager.delegate = PlatModel
            
        })
        .onChange(of: PlatModel.search, perform: {
            value in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                if value == PlatModel.search  && PlatModel.search != ""{
                    PlatModel.filterData()
                }
            }
        if PlatModel.search == ""{
            withAnimation(.linear){
               // PlatModel.fecthData(idResto: "1")
                PlatModel.filtered = PlatModel.items
            }
        }
        })
        
    }
    
}
struct ItemView: View {
    
    var item: Plat
    
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center), content: {
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 4, content: {
                        
                        Text(item.title)
                            .fontWeight(.heavy)
                        
                        Text("100")
                            .fontWeight(.heavy)
                    })
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    })
                }
                .padding([.horizontal,.top])
                .padding(.bottom,-15)
                
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170, height: 229)
                    .offset(x: -30)
            }
            // Both Image ANd COlor name are same....
            .background(
                Color("shake1")
                    .cornerRadius(35)
                    .clipShape(ItemCurve())
                    .padding(.bottom,35)
            )
            
            Button(action: {}, label: {
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("shake1"))
                    .clipShape(Circle())
            })
            .offset(y: -18)
        })
    }
}
/*dView : UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<AdView>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<AdView>) {
        
    }
}*/
// tabs...

var tabs = ["Sandwichs","Pizzas","Plats","Boissons"]

// Custom Curve....

struct Curve: Shape {
    
    var midY : CGFloat
    
    // animating...
    var animatableData: CGFloat{
        get{return midY}
        set{midY = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            
            // CUrve...
            let width = rect.width
            
            path.move(to: CGPoint(x: width, y: midY - 40))
            
            let to = CGPoint(x: width - 25, y: midY)
            let control1 = CGPoint(x: width, y: midY - 20)
            let control2 = CGPoint(x: width - 25, y: midY - 20)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: width, y: midY + 40)
            let control3 = CGPoint(x: width - 25, y: midY + 20)
            let control4 = CGPoint(x: width, y: midY + 20)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}

// Another Longer Curve For ItemView...

struct ItemCurve: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            
            // CUrve...
            let width = rect.width
            let midY = rect.height / 2
            
            path.move(to: CGPoint(x: width, y: midY - 60))
            
            let to = CGPoint(x: width - 40, y: midY)
            let control1 = CGPoint(x: width, y: midY - 30)
            let control2 = CGPoint(x: width - 40, y: midY - 30)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: width, y: midY + 60)
            let control3 = CGPoint(x: width - 40, y: midY + 30)
            let control4 = CGPoint(x: width, y: midY + 30)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}


struct PlatView_Previews: PreviewProvider {
    static var previews: some View {
        PlatView()
    }
}
