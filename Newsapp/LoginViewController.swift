//
//  LoginViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 15/08/2023.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var errorPW: UITextField!
    @IBOutlet weak var passworderrorIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        callAPI()
    }
    private var emailErrorMessage : String? {
        didSet {
            
        }
    }
//    private var passWordError : String? {
//        didSet {
//            let errorPW = passWordError != nil
//            if errorPW = "" {
//                pas
//            }
//        }
//    }
    func callAPI(){
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/login"
        AF.request(domain,method: HTTPMethod.post, parameters: ["username": emailTF.text, "password": passWord.text], encoder: JSONParameterEncoder.default)
            .responseData { (apiRespone: AFDataResponse<Data>) in
                switch apiRespone.result {
                case .success(let data) :
                    print(data)
                    do { guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        return
                    }
                    }
                        catch {
                            print("catch errror")
                        }
                    break
                        
                        
                case .failure(_):
                    print("failure")
                }
                }
            }
//        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/login", method: .post, parameters: [
//            "username": emailTF,
//            "password": passWord
//        ], encoder: JSONParameterEncoder.default)
//        .validate(statusCode: 200..<299)
//        .responseData { afDataResponse in
//            self.showLoading(isShow: false)
//            switch afDataResponse.result {
//                case .success(let data):}
//        }
        
    
    private func setupView(){
        errorView.isHidden = true
        clearBtn.isHidden = true
        errorPW.isHidden = true
        passworderrorIcon.isHidden = true
        
    }
    @objc private func emailTextFieldDidChange() {
        if let emailText = emailTF.text, !emailText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    @IBAction func onHandleButton(_ sender: Any) {
        errorView.isHidden = false
        clearBtn.isHidden = true
        errorPW.isHidden = true
        let passWordfield : String = passWord.text ?? ""
        if passWordfield.isEmpty {
            errorPW.text = "chua dien mat khau"
            passWord.backgroundColor = UIColor(red: 0.76, green: 0, blue: 0.32, alpha: 1)
            errorPW.isHidden = false
            passworderrorIcon.isHidden = false
            
        }
        else if passWordfield.count < 6 {
            errorPW.text = "mat khau dai hon 6 chu so"
            errorPW.backgroundColor = UIColor(red: 0.76, green: 0, blue: 0.32, alpha: 1)
            
            
        }
    }
    
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
}
