//
//  ViewController.swift
//  VKontakte
//
//  Created by Виктория Чубукова on 03.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
      
        let info = notification.userInfo! as NSDictionary
        
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    func checkUserData() -> Bool {
        guard let login = loginInput.text,
            let password = passwordInput.text else {
            print("неуспешная авторизация")
            return false }
        
        if login == "admin" && password == "12345678" {
            print("успешная авторизация")
            return true
        }
        print("неуспешная авторизация")
        return false
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }

    func showLoginError() {
        let alert = UIAlertController(title: "Error", message: "некорректный ввод", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "signIn" || checkUserData() { return true }
        showLoginError()
        return false
    }
}

