//
//  LoginSignUpRestaurant.swift
//  mini projet sim
//
//  Created by youssef benhissi on 09/01/2021.
//

import SwiftUI

import Combine
struct LoginSignUpRestaurant: View {
    var body: some View {
        LoginRestaurant()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
    }
}
enum PasswordStatusRestaurant{
    case empty
    case notStrongEnough
    case valid
}
enum emailLoginStatusRestaurant{
    case empty
    case notStrongEnough
    case valid
}
class  FormViewModelLoginRestaurant: ObservableObject{
    private static let predicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    @Published var email = ""
    @Published var password = ""
    
    @Published var inlineErrorForPassword = ""
    @Published var inlineErrorForEmail = ""
    @Published var isValid = false
    private var cancellables = Set<AnyCancellable>()
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never>{
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    private var isEmailValidPublisher: AnyPublisher<Bool, Never>{
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ Self.predicate.evaluate(with: $0)}
            .eraseToAnyPublisher()
    }
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never>{
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never>{
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count > 6}
            .eraseToAnyPublisher()
    }
    private var isLastemaileValidPublisher : AnyPublisher<emailStatus,Never>{
        Publishers.CombineLatest(isEmailEmptyPublisher,isEmailValidPublisher)
            .map{
                if $0 { return emailStatus.empty }
                if !$1 { return emailStatus.notStrongEnough }
                return emailStatus.valid
            }
            .eraseToAnyPublisher()
    }
    private var isPasswordValidPublisher : AnyPublisher<PasswordStatus,Never>{
        Publishers.CombineLatest(isPasswordEmptyPublisher,isPasswordStrongPublisher)
            .map{
                if $0 { return PasswordStatus.empty }
                if !$1 { return PasswordStatus.notStrongEnough }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    private var isFormValidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest(isPasswordValidPublisher, isEmailValidPublisher)
            .map { $0 == .valid && $1 }
            .eraseToAnyPublisher()
    }
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid , on: self )
            .store(in: &cancellables)
        isLastemaileValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ emailStatus in
                switch emailStatus {
                case .empty:
                    return "email ne doit pas être vide"
                case .notStrongEnough:
                    return "email n'est pas correct!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForEmail , on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ PasswordStatus in
                switch PasswordStatus {
                case .empty:
                    return "le mot de passe ne doit pas etre vide"
                case .notStrongEnough:
                    return "le mot de passe est erroné"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForPassword , on: self)
            .store(in: &cancellables)
        
        
        
    }
}
struct LoginSignUpRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpRestaurant()
    }
}
struct LoginRestaurant: View {
    @StateObject private var formViewModel = FormViewModelLoginRestaurant()
    @State var email = ""
    @StateObject var PlatModel = PlatViewModel()
    @State var password = ""
    @Namespace var animation
    @State var isModal: Bool = false
    @State var show = false
    @State private var activeSheet: ActiveSheet = .first
    @State var message = ""
    @State var customAlert = false
    var body: some View {
        
        VStack{
           
            HStack{
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Login")
                        .font(.system(size: 40, weight: .heavy))
                        // for Dark Mode Adoption...
                        .foregroundColor(.primary)
                    
                    Text("Please sign in to continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.leading)
            
            CustomTextField(image: "envelope", title: "EMAIL", value: $formViewModel.email,animation: animation)
            Text(formViewModel.inlineErrorForEmail)
                .foregroundColor(.red)
            
            CustomTextField(image: "lock", title: "PASSWORD", value: $formViewModel.password,animation: animation)
                .padding(.top,5)
            Text(formViewModel.inlineErrorForPassword)
                .foregroundColor(.red)
            HStack{
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 20) {
                    
                    
                    Button(action: {
                        PlatModel.loginRestaurant(email: formViewModel.email, password: formViewModel.password)
                       
                       // var etat = PlatModel.login(email: formViewModel.email, password: formViewModel.password)
                        print(PlatModel.etatLogin)
                        if PlatModel.loginString == ""
                        {
                            self.customAlert = true
                            self.activeSheet = .first
                            
                        }
                        if PlatModel.loginString == "le mot de passe est erroné"
                        {
                            self.customAlert = true
                            message = "le mot de passe est erroné"
                            self.activeSheet = .second
                        }
                        if PlatModel.loginString == "Aucun utilisateur est trouvé avec ces informations"
                        {
                            self.customAlert = true
                            message = "Aucun utilisateur est trouvé avec ces informations"
                            self.activeSheet = .second
                        }
                    }) {
                        
                        HStack(spacing: 10){
                            
                            Text("LOGIN")
                                .fontWeight(.heavy)
                            
                            Image(systemName: "arrow.right")
                                .font(.title2)
                        }
                        .modifier(CustomButtonModifier())

                    }.sheet(isPresented: $customAlert) {
                        if self.activeSheet == .first {
                            LandingView()
                                        }
                                        else {
                                            CustomAlertView(show: $customAlert, message: $PlatModel.loginString)
                                        }
                        
                    }.disabled(!formViewModel.isValid)
                }
            }
            .padding()
            .padding(.top,10)
            .padding(.trailing)
            
           
        }
    }
}


struct CustomTextField: View {
    
    // Fields...
    var image: String
    var title: String
    @Binding var value: String
    
    var animation: Namespace.ID
    
    var body: some View {
        
        VStack(spacing: 6){
            
            HStack(alignment: .bottom){
                
                Image(systemName: image)
                    .font(.system(size: 22))
                    .foregroundColor(value == "" ? .gray : .primary)
                    .frame(width: 35)
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    if value != ""{
                        
                        Text(title)
                            
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                            .matchedGeometryEffect(id: title, in: animation)
                    }
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        
                        if value == ""{
                            
                            Text(title)
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundColor(.gray)
                                .matchedGeometryEffect(id: title, in: animation)
                        }
                        
                        if title == "PASSWORD"{
                            
                            SecureField("", text: $value)
                        }
                        else{
                            TextField("", text: $value)
                                .autocapitalization(.none)
                            // For Phone Number...
                                .keyboardType(title == "PHONE NUMBER" ? .numberPad : .default)
                        }
                    }
                }
            }
            
            if value == ""{
                
                Divider()
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        .background(Color("txtrest").opacity(value != "" ? 1 : 0))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(value == "" ? 0 : 0.1), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(value == "" ? 0 : 0.05), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        .padding(.top)
        .animation(.linear)
    }
}



struct Register: View {
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var number = ""
    
    @Binding var show : Bool
    
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack{
                
                HStack{
                    
                    Button(action: {show.toggle()}) {
                        
                        Image(systemName: "arrow.left")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .padding(.leading)
                
                HStack{
                    
                    Text("Create Account")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading)
                
                CustomTextField(image: "person", title: "FULL NAME", value: $name, animation: animation)
                
                CustomTextField(image: "envelope", title: "EMAIL", value: $email, animation: animation)
                    .padding(.top,5)
                
                CustomTextField(image: "lock", title: "PASSWORD", value: $password, animation: animation)
                    .padding(.top,5)
                
                CustomTextField(image: "phone.fill", title: "PHONE NUMBER", value: $number, animation: animation)
                    .padding(.top,5)
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {}) {
                        
                        HStack(spacing: 10){
                            
                            Text("SIGN UP")
                                .fontWeight(.heavy)
                            
                            Image(systemName: "arrow.right")
                                .font(.title2)
                        }
                        .modifier(CustomButtonModifier())

                    }
                }
                .padding()
                .padding(.top)
                .padding(.trailing)
                
                HStack{
                    
                    Text("Already have a account?")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Button(action: {show.toggle()}) {
                        
                        Text("sign in")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("yellowrest"))
                    }
                }
                .padding()
                .padding(.top,10)
                
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}



struct CustomButtonModifier: ViewModifier {

    func body(content: Content) -> some View {
        
        return content
            .foregroundColor(.white)
            .padding(.vertical)
            .padding(.horizontal,35)
            .background(
            
                LinearGradient(gradient: .init(colors: [Color("yellow-lightrest"),Color("yellowrest")]), startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
    }
}
   
