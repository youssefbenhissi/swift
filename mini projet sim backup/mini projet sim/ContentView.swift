//
//  ContentView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 23/11/2020.
//

import SwiftUI
import MapKit
import FBSDKLoginKit
import GoogleSignIn
import LocalAuthentication
struct ContentView: View  {
    @AppStorage("status") var logged = false
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            if logged{
                if UIScreen.main.bounds.height > 800{
                    Home()
                }
                else{
                    ScrollView(.vertical,showsIndicators : false){
                        Home()
                    }
                }
                
            }}
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Home : View {
    // when first time user logged in via email store this for future biometric login....
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @State var manager = LoginManager()
    @AppStorage("stored_User") var user = "youssef.benhissi@esprit.tn"
    @State var index = 0
    @State var isModal: Bool = false
    var body: some View{
        VStack{
            Image("new_final_logo")
                .resizable()
                .frame(width: 200, height: 180)
            HStack{
                Button(action:  {
                    withAnimation(.spring(response: 0.8,dampingFraction: 0.5,blendDuration: 0.5)){
                        self.index = 0
                    }
                    
                }){
                    Text("Existant")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical,10)
                        .frame(width: (UIScreen.main.bounds.width - 50 )/2)
                }.background(self.index == 0 ? Color.white : Color.clear)
                .clipShape(Capsule())
                
                Button(action:  {
                    withAnimation(.spring(response: 0.8,dampingFraction: 0.5,blendDuration: 0.5)){
                        self.index = 1
                    }
                }){
                    Text("Nouveau")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical,10)
                        .frame(width: (UIScreen.main.bounds.width - 50 )/2)
                }.background(self.index == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
                
            }.background(Color.black.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top,25)
            if self.index == 0{
                
                Login()
            }else{
                Signup()
            }
            
            HStack(spacing: 15){
                Color.white.opacity(0.7)
                    .frame(width: 35, height: 1)
                Text("Or")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Color.white.opacity(0.7)
                    .frame(width: 35, height: 1)
            }
            .padding(.top,10)
            HStack{
                Button(action: {
                    if(logged){
                        manager.logOut();
                        email = ""
                        logged = false
                    }
                    else{
                        manager.logIn(permissions:["public_profile","email"] , from: nil){
                            (result,err)in
                            if err != nil{
                                print()
                            }
                            if !result!.isCancelled{
                                logged = true
                                let request = GraphRequest(graphPath: "me",parameters: ["fields" : "email"])
                                request.start{(_,res,_) in
                                    guard let profileData = res as? [String:Any]
                                    else{
                                            return
                                    }
                                    email =  profileData["email"] as! String
                                    self.isModal = true
                                }
                            }
                           
                        }
                    }
                }){
                    Image("fb")
                        .resizable()
                        .renderingMode(.original)
                        .padding()
                        .frame(width: 70, height: 70)
                }.background(Color.white)
                .clipShape(Circle())
                Button(action: {
                   // GIDSignIn.sharedInstance()?.presentingViewController = self
                    if(GIDSignIn.sharedInstance()?.presentingViewController==nil){
                        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
                    }	
                    GIDSignIn.sharedInstance().signIn()
                }){
                    Image("google")
                        .resizable()
                        .renderingMode(.original)
                        .padding()
                        .frame(width: 70, height: 70)
                }.background(Color.white)
                .clipShape(Circle())
                .sheet(isPresented: $isModal) {
                        ListRestaurants()
                }
                .padding(.leading,25)
            }
            .padding(.top,10)
        }
        .padding()
    }
}
struct SignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        // Customize button here
        button.colorScheme = .light
        return button
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
struct Login : View{
    @AppStorage("stored_User") var user = "youssef.benhissi@esprit.tn"
    @AppStorage("status") var logged = false
    @State var mail = ""
    @State var pass = ""
    @State var hide = true
    @State var isModal: Bool = false
    @State var isModalRestaurantDetail: Bool = false
    @StateObject var PlatModel = PlatViewModel()
    var  body : some View{
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    TextField("Email Addresse", text: self.$mail)
                        .autocapitalization(.none)
                }.padding(.vertical,20)
                Divider()
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    if self.hide{
                        SecureField("Mot de passe", text: self.$pass)
                        .autocapitalization(.none)
                        
                    }else{
                        TextField("Mot de passe", text: self.$pass)
                        .autocapitalization(.none)
                    }
                    
                    Button(action : {
                        self.hide.toggle()
                    }){
                        Image(systemName: self.hide ? "eye.fill" : "eye.slash.fill" )
                            .foregroundColor((self.hide == true) ?
                                             Color.black : Color.gray
                            )
                    }
                    
                }.padding(.vertical,20)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom,40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top)
            
            HStack(spacing:15){
                
                
                
                Button(action:{
                    
                 //   var etat = PlatModel.login(email: "youssef.benhissi@esprit.tn", password: (pass))
                    self.isModal = true
                }){
                    Text("s'identifier")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 200)
                }
                .sheet(isPresented: $isModal) {
                        ListRestaurants()
                }
                .background(LinearGradient(gradient: .init(colors:[Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
                .offset(y:-40)
                .padding(.bottom, -40)
                .shadow(radius: 15)
                if getBioMetricStatus(){
                    
                    Button(action: authenticateUser, label: {
                        
                        // getting biometrictype...
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("green"))
                            .clipShape(Circle())
                    })
                }
            }
        }
    }
    func getBioMetricStatus()->Bool{
        
        let scanner = LAContext()
        if mail == user && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none){
            
            return true
        }
        
        return false
    }
    
    // authenticate User...
    
    func authenticateUser(){
        
        guard #available(iOS 8.0, *) else {
            return print("Not supported")
        }
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return print(error)
        }
        
        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized == true else {
                return print(error)
            }
            
            Accueil()
        }
    }
}
struct Signup : View{
    @State var mail = ""
    @State var nom = ""
    @State var prenom = ""
    @State var pass = ""
    @State var repass = ""
    @State var isModal: Bool = false
    @StateObject var PlatModel = PlatViewModel()
    @State var hide = true
    var  body : some View{
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                    TextField("Saisir votre nom", text: self.$nom)
                        .autocapitalization(.none)
                }.padding(.vertical,20)
                Divider()
                HStack(spacing: 15){
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                    if mail.isEmpty { Text("Placeholder")
                        .foregroundColor(.red)
                        .background(Color.yellow)
                    }
                    TextField("", text: self.$mail)
                        .background(mail.isEmpty ? Color.clear : Color.yellow)
                }.padding(.vertical,20)
                Divider()
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    TextField("Enter Email Address", text: self.$mail)
                        .autocapitalization(.none)
                }.padding(.vertical,20)
                Divider()
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if self.hide{
                        SecureField("Mot de passe", text: self.$pass)
                        .autocapitalization(.none)
                        
                    }else{
                        TextField("Mot de passe", text: self.$pass)
                        .autocapitalization(.none)
                    }
                    
                    Button(action : {
                        self.hide.toggle()
                    }){
                        Image(systemName: self.hide ? "eye.fill" : "eye.slash.fill" )
                            .foregroundColor((self.hide == true) ?
                                             Color.black : Color.gray
                            )
                    }
                    
                }.padding(.vertical,20)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom,40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top)
            
            
            /*
             Button(action:{
                 self.isModal = true
             }){
                 Text("LOGIN")
                     .foregroundColor(.white)
                     .fontWeight(.bold)
                     .padding(.vertical)
                     .frame(width: UIScreen.main.bounds.width - 200)
             }
             .sheet(isPresented: $isModal) {
                 HomeCli()
             }
             **/
            
            Button(action:{
                self.isModal = true
                PlatModel.register(firstName: (nom), lastname: (prenom), email: (mail), password: (pass))
                
            }){
                Text("S'inscrire")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
            }
            .sheet(isPresented: $isModal) {
                HomeCli()
            }
            .background(LinearGradient(gradient: .init(colors:[Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(8)
            .offset(y:-40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }
    
}


