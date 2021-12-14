//
//  Payment.swift
//  mini projet sim
//
//  Created by youssef benhissi on 12/12/2020.
//

import SwiftUI
import Razorpay
import UIKit
struct Payment: View {
    var body: some View {
        Button(action: {
            
            pay().showPaymentForm()
            
        }) {
            
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        }
    }
}

struct Payment_Previews: PreviewProvider {
    static var previews: some View {
        Payment()
    }
}

class pay:   UIViewController,RazorpayPaymentCompletionProtocol  {
    var razorpay: RazorpayCheckout!
       override func viewDidLoad() {
            super.viewDidLoad()
            razorpay = RazorpayCheckout.initWithKey("rzp_test_P8sFfdgN70Bflb", andDelegate: self)
        }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.showPaymentForm()
        }
    func onPaymentError(_ code: Int32, description str: String) {
        print("Payment failed with code: \(code), msg: \(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("Payment Success payment id: \(payment_id)")

    }
    func showPaymentForm(){
        razorpay = RazorpayCheckout.initWithKey("rzp_test_GKPJoEXR4QBjZG", andDelegate: self)
        let options: [String:Any] = [
                    "amount": "2000", //This is in currency subunits. 100 = 100 paise= INR 1.
                    "description": "purchase description",
                    "order_id": "order_DBJOWzybf0sJbb",
                    "image": "https://cdn.razorpay.com/logos/Du3F12cJXffdFe_large.png",
                    "name": "business or product name",
                    "prefill": [
                        "email": "youssef.benhissi@esprit.tn"
                    ],
                    "theme": [
                        "color": "#F37254"
                      ]
                ]
        razorpay.open(options)
    }
    
    
}
