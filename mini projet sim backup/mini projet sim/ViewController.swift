//
//  ViewController.swift
//  mini projet sim
//
//  Created by youssef benhissi on 25/12/2020.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {
    var alphas : [String] = []
    var captchaString = ""
    var i1 : Int = 0
    var i2 : Int = 0
    var i3 : Int = 0
    var i4 : Int = 0
    @IBOutlet weak var CaptchaLabel: UILabel!
    @IBOutlet weak var CaptchaTextField: UITextField!
    @IBOutlet weak var StatusLabel: UILabel!
    var i5 : Int = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        alphas = ["0","1","2","3","4","5","6","7","8","9","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        
     //   self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadCaptcha()
    }
    func reloadCaptcha(){
        i1 = Int(arc4random()) % alphas.count
        i2 = Int(arc4random()) % alphas.count
        i3 = Int(arc4random()) % alphas.count
        i4 = Int(arc4random()) % alphas.count
        i5 = Int(arc4random()) % alphas.count
        captchaString = "\(alphas[i1])\(alphas[i2])\(alphas[i3])\(alphas[i4])\(alphas[i5])"
        print(captchaString)
        CaptchaLabel.text = captchaString
    }
    
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        //reloadCaptcha()
        
    }
    @IBSegueAction func SwiftuiAction(_ coder: NSCoder) -> UIViewController? {
        reloadCaptcha()
        return UIHostingController(coder: coder, rootView: LiquidSwipeView())
    }
    
    @IBAction func ReloadButton(_ sender: UIButton) {
        if CaptchaLabel.text == CaptchaTextField.text{
            StatusLabel.text = "Success"
            
           
            StatusLabel.textColor = .green
        }
        else{
            StatusLabel.text = "Faile"
            StatusLabel.textColor = .red
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
