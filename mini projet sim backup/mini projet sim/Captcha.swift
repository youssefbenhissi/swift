//
//  Captcha.swift
//  mini projet sim
//
//  Created by youssef benhissi on 25/12/2020.
//

import SwiftUI

struct Captcha: View {
    var body: some View {
        CustomController()
    }
}

struct Captcha_Previews: PreviewProvider {
    static var previews: some View {
        Captcha()
        
    }
}
struct CustomController : UIViewControllerRepresentable{
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Custom", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
        
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
