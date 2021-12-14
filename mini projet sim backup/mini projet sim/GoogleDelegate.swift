//
//  GoogleDelegate.swift
//  mini projet sim
//
//  Created by youssef benhissi on 25/12/2020.
//

import Foundation
import GoogleSignIn
class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // If the previous `error` is null, then the sign-in was succesful
        print("Successful sign-in!")
        signedIn = true
    }
}
