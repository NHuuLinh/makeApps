//
//  LoginViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 15/08/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var clearBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
    }
    private func setupView(){
        errorView.isHidden = true
        clearBtn.isHidden = true
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
    }
    
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
}
