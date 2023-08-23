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
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var errorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var passwordErorrView: UIView!
    @IBOutlet weak var passwordTextView: UIView!
    @IBOutlet weak var passwordErrorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var nameErorrView: UIView!
    @IBOutlet weak var nameTextView: UIView!
    @IBOutlet weak var nameErrorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var nameErorText: UITextField!
    @IBOutlet weak var nameClearBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        
    }
    struct RegistrationParameters: Encodable {
        let email: String
        let name: String
        let password: String
    }
    func callAPIRegister(email: String, name: String, password: String) {
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
        
        let parameters = RegistrationParameters(email: email, name: name, password: password)
        
        AF.request(domain, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseData { afResponse in
                switch afResponse.result {
                case .success(let data):
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            return
                        }
                        
                        print(json)
                        let type = json["type"] as? String
                        let message = json["message"] as? String
                        let loginResbyObjectMapper = LoginResponseByObjectMapper(JSON: json)
                        let isRegistered = loginResbyObjectMapper?.accessToken != nil
                        
                        if isRegistered {
                            self.showSuccessAlert(message: "đưng kí thành công")
                        } else {
                            if let errorMessage = message {
                                self.showErrorAlert(message: errorMessage)
                            } else {
                                self.showErrorAlert(message: "đăng kí thất bại")
                            }
                        }
                    } catch {
                        self.showErrorAlert(message: "lỗi không xác định")
                    }
                    break
                case .failure(let err):
                    print(err.errorDescription ?? "")
                    print(err)
                    if let data = afResponse.data {
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                                self.showErrorAlert(message: "lỗi không xác định")
                                return
                            }
                            print(json)
                        } catch {
                            self.showErrorAlert(message: "lỗi không xác định")
                        }
                    }
                    break
                }
            }
    }
    private func setupView(){
        clearBtn.isHidden = true
        errorView.isHidden = true
        errorViewHieght.constant = 0
        emailTextView.layoutIfNeeded()
        emailTextView.layer.borderWidth = 2
        emailTextView.layer.cornerRadius = 6
        emailTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        
        passwordErorrView.isHidden = true
        passwordErrorViewHieght.constant = 0
        passwordErorrView.layoutIfNeeded()
        passwordTextView.layer.borderWidth = 2
        passwordTextView.layer.cornerRadius = 6
        passwordTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        
        nameErorrView.isHidden = true
        nameErrorViewHieght.constant = 0
        nameErorrView.layoutIfNeeded()
        nameTextView.layer.borderWidth = 2
        nameTextView.layer.cornerRadius = 6
        nameTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
    }
    @objc private func emailTextFieldDidChange() {
        if let emailText = emailTF.text, !emailText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    @objc private func nameTextFieldDidChange() {
        if let nameText = nickNmaeTF.text, !nameText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    
    
    func checkValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func nameClearButton(_ sender: Any) {
        nickNmaeTF.text = ""
        nameClearBtn.isHidden = true
        
    }
    func showSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func onHandleValidateForm(email: String, password: String, name: String) -> Bool {
        var isEmailValid = false
        if email.isEmpty {
            emailerrorTF.text = "không thể để trống email"
            errorView.isHidden = false
            emailTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            errorViewHieght.constant = 21
            emailTextView.layoutIfNeeded()
        } else if (!checkValidEmail(email)) {
            emailerrorTF.text = "email không hợp lệ"
            errorView.isHidden = false
            emailTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            errorViewHieght.constant = 21
            emailTextView.layoutIfNeeded()
        }
        else {
            isEmailValid = true
            errorView.isHidden = true
            emailTextView.backgroundColor = .clear
            errorViewHieght.constant = 0
            emailTextView.layoutIfNeeded()
        }
        
        var isPasswordValid = false
        if password.isEmpty {
            passwordErorrView.isHidden = false
            passwordErorrView.layoutIfNeeded()
            errorPW.text = "không thể để trống password"
            passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            passwordErrorViewHieght.constant = 21
            passwordErorrView.layoutIfNeeded()
        }else if password.count < 6 {
            passwordErorrView.isHidden = false
            passwordErorrView.layoutIfNeeded()
            errorPW.text = "mật khẩu dài hơn 6 kí tự"
            passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            passwordErrorViewHieght.constant = 21
        }else if password.count > 40 {
            passwordErorrView.isHidden = false
            passwordErorrView.layoutIfNeeded()
            errorPW.text = "mật khẩu không dài hơn 40 kí tự"
            passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            passwordErrorViewHieght.constant = 21
        } else {
            passwordErorrView.isHidden = true
            passwordErorrView.layoutIfNeeded()
            passwordTextView.backgroundColor = .clear
            passwordErrorViewHieght.constant = 0
            isPasswordValid = true
        }
        
        var isNameValid = false
        if name.isEmpty {
            nameErorrView.isHidden = false
            nameErorrView.layoutIfNeeded()
            nameErorText.text = "không thể để trống password"
            nameTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            nameErrorViewHieght.constant = 21
            nameErorrView.layoutIfNeeded()
        } else {
            nameErorrView.isHidden = true
            nameErorrView.layoutIfNeeded()
            nameTextView.backgroundColor = .clear
            nameErrorViewHieght.constant = 0
            isNameValid = true
        }
        let isValid = isEmailValid && isPasswordValid && isNameValid
        return isValid
    }
    @IBAction func onHandleButton(_ sender: Any) {
        errorView.isHidden = true
        clearBtn.isHidden = true
        let email = emailTF.text ?? "";
        let password = passWordTF.text ?? "";
        let name = nickNmaeTF.text ?? "";
        let isValid = onHandleValidateForm(email: email, password: password, name: name)
        
        guard isValid else {
            return
        }
        callAPIRegister(email: email, name: name, password: password)
    }
    @IBAction func Loginbutton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func HiddenButton(_ sender: Any) {
        passWordTF.isSecureTextEntry = !passWordTF.isSecureTextEntry

    }
    
}

