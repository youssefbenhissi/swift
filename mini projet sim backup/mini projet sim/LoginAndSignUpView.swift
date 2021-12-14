//
//  LoginAndSignUpView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 26/12/2020.
//

import SwiftUI
import Combine
import FBSDKLoginKit
import LocalAuthentication
import GoogleSignIn
import LocalAuthentication
struct BlurView : UIViewRepresentable {
    func makeUIView(context : Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
struct CustomAlertView : View {
    @Binding var show : Bool
    @Binding var message : String
    
    var body: some View{
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
                Image(systemName: "exclamationmark.shield")
                    .foregroundColor(.red)
                Text("Attention")
                    .font(.title)
                    .foregroundColor(.pink)
                Text(message)
                Button(action: {show.toggle()}){
                    Text("Retour")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical,10)
                        .padding(.horizontal,25)
                        .background(Color.purple)
                        .clipShape(Capsule())
                    
                    
                }
            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .cornerRadius(25)
            .background(BlurView())
            
            Button(action: {withAnimation{ show.toggle() }}){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.purple)
            }
            .padding()
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.35))
    }
}
enum PasswordStatus{
    case empty
    case notStrongEnough
    case valid
}	
enum NameStatus{
    case empty
    case notStrongEnough
    case valid
}
enum LastNameStatus{
    case empty
    case notStrongEnough
    case valid
}
enum emailStatus{
    case empty
    case notStrongEnough
    case valid
}
enum emailLoginStatus{
    case empty
    case notStrongEnough
    case valid
}
enum NameLoginStatus{
    case empty
    case notStrongEnough
    case valid
    
}
class  FormViewModelLogin: ObservableObject{
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
class  FormViewModel: ObservableObject{
    
    private static let predicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    @Published var nom = ""
    @Published var prenom = ""
    @Published var email = ""
    @Published var password = ""
    @Published var inlineErrorForPassword = ""
    @Published var inlineErrorForEmail = ""
    @Published var inlineErrorForName = ""
    @Published var inlineErrorForLastName = ""
     @Published var isValid = false
    private var cancellables = Set<AnyCancellable>()
    
    private var isNameValidPublisher: AnyPublisher<Bool, Never>{
        $nom
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count > 3}
            .eraseToAnyPublisher()
    }
    private var isNameEmptyPublisher: AnyPublisher<Bool, Never>{
        $nom
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    private var isLastNameValidPublisher: AnyPublisher<Bool, Never>{
        $prenom
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count > 3}
            .eraseToAnyPublisher()
    }
    private var isLastNameEmptyPublisher: AnyPublisher<Bool, Never>{
        $prenom
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
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never>{
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
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
    private var isPasswordValidPublisher : AnyPublisher<PasswordStatus,Never>{
        Publishers.CombineLatest(isPasswordEmptyPublisher,isPasswordStrongPublisher)
            .map{
                if $0 { return PasswordStatus.empty }
                if !$1 { return PasswordStatus.notStrongEnough }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    private var isNameeValidPublisher : AnyPublisher<NameStatus,Never>{
        Publishers.CombineLatest(isNameEmptyPublisher,isNameValidPublisher)
            .map{
                if $0 { return NameStatus.empty }
                if !$1 { return NameStatus.notStrongEnough }
                return NameStatus.valid
            }
            .eraseToAnyPublisher()
    }
    private var isLastNameeValidPublisher : AnyPublisher<LastNameStatus,Never>{
        Publishers.CombineLatest(isLastNameEmptyPublisher,isLastNameValidPublisher)
            .map{
                if $0 { return LastNameStatus.empty }
                if !$1 { return LastNameStatus.notStrongEnough }
                return LastNameStatus.valid
            }
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
    private var isFormValidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest(isPasswordValidPublisher, isNameValidPublisher)
            .map { $0 == .valid && $1 }
            .eraseToAnyPublisher()
    }
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid , on: self )
            .store(in: &cancellables)
        isNameeValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ NameStatus in
                switch NameStatus {
                case .empty:
                    return "le nom ne doit pas être vide"
                case .notStrongEnough:
                    return "le nom est trop court!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForName , on: self)
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
        isLastNameeValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ LastNameStatus in
                switch LastNameStatus {
                case .empty:
                    return "le prénom ne doit pas être vide"
                case .notStrongEnough:
                    return "le prénom est trop court!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForLastName , on: self)
            .store(in: &cancellables)
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ PasswordStatus in
                switch PasswordStatus {
                case .empty:
                    return "Password cannot be empty"
                case .notStrongEnough:
                    return "Password is too weak!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForPassword , on: self)
            .store(in: &cancellables)
    }
}


struct LoginAndSignUpView: View {
    var body: some View {
        LoginAndSign()
            .preferredColorScheme(.dark)
    }
}

struct LoginAndSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginAndSignUpView()
    }
}
struct LoginAndSign : View{
    
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @State var manager = LoginManager()
    @State var isModal: Bool = false
   @State var index = 0
    var body: some View{
        GeometryReader{_ in
            VStack{
               
                Image("logologin")
                                 .resizable()
                                 .frame(width: 60, height: 60)
                ZStack{
                    signuppage(index: self.$index)
                        .zIndex(Double(self.index))
                    Loginpage(index: self.$index)
                    
                }
                HStack(spacing: 15){
                    Rectangle()
                        .fill(Color("Colorlogin1"))
                        .frame(height: 1)
                    Text("Or")
                    Rectangle()
                        .fill(Color("Colorlogin1"))
                        .frame(height: 1)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                HStack(spacing: 25){
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
                        Image("fblogin")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $isModal) {
                        HomeCli()
                    }
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
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $isModal) {
                        HomeCli()
                    }
                }
                .padding(.top, 30)
                
            }
            .padding(.vertical)
        }
        .background(Color("Colorlogin").edgesIgnoringSafeArea(.all))
        
        
    }
    
}
struct CShape : Shape {
    
    func path(in rect:CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
struct CShape1 : Shape {
    
    func path(in rect:CGRect) -> Path {
        return Path{path in
            //left side curve
            
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
enum ActiveSheet {
   case first, second
}
struct Loginpage : View{
    @AppStorage("stored_User") var user = "youssef.benhissi@esprit.tn"
    @StateObject private var formViewModel = FormViewModelLogin()
    @State var customAlert = false
    
    @Namespace var animation
    @StateObject var PlatModel = PlatViewModel()
    @State var email = ""
    @State private var activeSheet: ActiveSheet = .first
    @State var message = ""
    @State var isModal: Bool = false
    @State var pass = ""
    @Binding var index : Int
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                HStack{
                    VStack(spacing: 10){
                        Text("Login")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 30)
                CustomTextField(image: "envelope", title: "EMAIL", value: $formViewModel.email,animation: animation)
                Text(formViewModel.inlineErrorForEmail)
                    .foregroundColor(.red)
                CustomTextField(image: "lock", title: "PASSWORD", value: $formViewModel.password,animation: animation)
                    .padding(.top,5)
                Text(formViewModel.inlineErrorForPassword)
                    .foregroundColor(.red)
                HStack{
                    Spacer(minLength: 0)
                    Button(action: {
                        PlatModel.forgetPassword(email: formViewModel.email)
                        //print(PlatModel.nouveauemotdepasse)
                        self.isModal = true
                    })
                    {
                        
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    .sheet(isPresented: $isModal) {
                        lock(key: $PlatModel.nouveauemotdepasse)
                    }
                }
                .padding(.horizontal)
                .padding(.top,30)
            }
            .padding()
            .padding(.bottom,65)
            .background(Color("Colorlogin2"))
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            HStack{
            
            //button action
            Button(action: {
                PlatModel.login(email: formViewModel.email, password: formViewModel.password)
               
               // var etat = PlatModel.login(email: formViewModel.email, password: formViewModel.password)
                print(PlatModel.etatLogin)
                if PlatModel.loginString == ""
                {
                    print("ssssss")
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
                // print(etat)
            }){
                Text("Login")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal,50)
                    .background(Color("Colorlogin1"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                
            }
            	
            .sheet(isPresented: $customAlert) {
                if self.activeSheet == .first {
                    scroll()
                                }
                                else {
                                    CustomAlertView(show: $customAlert, message: $PlatModel.loginString)
                                }
                
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
            .disabled(!formViewModel.isValid)
            if getBioMetricStatus(){
                
                Button(action: authenticateUser, label: {
                    
                    // getting biometrictype...
                    Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                        .foregroundColor(.white)
                        .background(Color("Colorlogin1"))
                        .clipShape(Capsule())
                        .frame(width: 32.0, height: 32.0)
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }).offset(y: 25)
                .opacity(self.index == 0 ? 1 : 0)
                
                
            } }
        }
    }
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
            
            scroll()
        }
    }
    func getBioMetricStatus()->Bool{
        
        let scanner = LAContext()
        if formViewModel.email == user && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none){
            
            return true
        }
        
        return false
    }
}
enum BiometricType {
    case none
    case touch
    case face
}


struct signuppage : View{
    
    @StateObject private var formViewModel = FormViewModel()
    
    
    @State var email = ""
    
    @Namespace var animation
    @State var pass = ""
    @State var nom = ""
    @StateObject var PlatModel = PlatViewModel()
    @State var prenom = ""
    @State var Repass = ""
    @Binding var index: Int
    @State var isModal: Bool = false
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                HStack{
                    Spacer(minLength: 0)
                    VStack(spacing: 10){
                        Text("SignUp")
                            .foregroundColor(self.index == 1 ? .white :.gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    
                    
                }
                .padding(.top, 30)
                
                CustomTextField(image: "person", title: "NOM", value: $formViewModel.nom,animation: animation)
                Text(formViewModel.inlineErrorForName)
                    .foregroundColor(.red)
                
                CustomTextField(image: "person", title: "PRENOM", value: $formViewModel.prenom,animation: animation)
                
                Text(formViewModel.inlineErrorForLastName)
                    .foregroundColor(.red)
                CustomTextField(image: "envelope.fill", title: "EMAIL", value: $formViewModel.email,animation: animation)
                
                Text(formViewModel.inlineErrorForEmail)
                    .foregroundColor(.red)
                CustomTextField(image: "eye.slash.fill", title: "PASSWORD", value: $formViewModel.password,animation: animation)
                
                Text(formViewModel.inlineErrorForPassword)
                    .foregroundColor(.red)
                    
               //replacing forget password with reenter password
                // so same height will be maintened ...
                
            }
            .padding()
            .padding(.bottom,65)
            .background(Color("Colorlogin2"))
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            //button action
            Button(action: {
                self.isModal = true
                PlatModel.register(firstName: (nom), lastname: (prenom), email: (email), password: (pass))
            }){
                Text("Sign Up")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal,50)
                    .background(Color("Colorlogin1"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            
            .sheet(isPresented: $isModal) {
                HomeCli()
            }
            .offset(y: 25)
            .opacity(self.index == 1 ? 1 : 0)
            .disabled(!formViewModel.isValid)
        }
    }
}

