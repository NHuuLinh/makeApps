//
//  RegisterViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 19/08/2023.
//

import UIKit
import Alamofire
import ObjectMapper


class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var emailerrorTF: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var errorPW: UITextField!
    @IBOutlet weak var passworderrorIcon: UIImageView!
    @IBOutlet weak var nickNmaeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        
    }
    struct RegistrationParameters: Encodable {
        let username: String
        let name: String
        let password: String
    }
    func callAPI(username: String, name: String, password: String) {
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
        
        let parameters = RegistrationParameters(username: username, name: name, password: password)
        
        AF.request(domain, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseData { afResponse in
                switch afResponse.result {
                case .success(let data):
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            return
                        }
                        
                        print(json)
                        print("json")
                        self.registedSuccess()
                        
                        
                    } catch {
                        print("errorMsg")
                        self.registedError(message: "erorCatch")
                    }
                    break
                case .failure(let error):
                    print("failure")
                    print(error)
                    guard let data = afResponse.data else {
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            self.registedError(title: "Lỗi", message: "lỗi không xác định")
                            
                            return
                        }
                        //lỗi trả về từ server
                        print(json)
                        let type = json["type"]as? String
                        let message = json["message"]as? String
                        let loginResbyObjectMapper = LoginResponseByObjectMapper(JSON: json)
                        let isLoggedIn = loginResbyObjectMapper?.accessToken != nil
                        //                        self.registedError(title: type ?? "Lỗi", message: message ?? "lỗi không xác định")
                    } catch {
                        print("errorMsg")
                    }
                    break
                }
            }
    }
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
        errorView.isHidden = true
        clearBtn.isHidden = true
        errorPW.isHidden = true
        
        let name = nickNmaeTF.text ?? ""
        let username = emailTF.text ?? ""
        let password = passWordTF.text ?? ""
        
        if name.isEmpty {
            emailerrorTF.text = "không thể để trống tên"
        }else if name.count > 40 {
            
        }
        
        else if !isValidEmail(email: username) {
        } else if password.isEmpty || password.count < 6 || password.count > 40 {
        } else {
            callAPI(username: username, name: name, password: password)
        }
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
    private func registedSuccess() {
        let alertVC = UIAlertController(title: "Thông báo", message: "đăng kí tài khoản thành công!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    private func registedError(title: String? = "Lỗi", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
//    private func onHandleValidateForm(username: String,email: String, password: String) -> Bool {
//        var isEmailValid = false
//        if email.isEmpty {
//            emailerrorTF.text = "Email can't empty"
//        }
//        else if (!isValidEmail(email: email)) {
//            emailerrorTF.text = "Email invalid"
//        }
//        else {
//            emailerrorTF = nil
//            isEmailValid = true
//        }
//
//        var isPasswordValid = false
//        if password.isEmpty {
//            errorPW.text = "Password can't empty"
//        }
//        else if password.count < 6 {
//            errorPW.text = "Password must be at least 6 characters long."
//        }
//        else {
//            errorPW = nil
//            isPasswordValid = true
//        }
//        let isValid = isEmailValid && isPasswordValid
//        return isValid
//    }
//    func emailvalid() {
//        let emailTextField : String = emailTF.text ?? ""
//        let passWordfield : String = passWordTF.text ?? ""
//        if emailTextField.isEmpty {
//            emailerrorTF.text = "không để trống mật khẩu"
//        }
//            }
}
