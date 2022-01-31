//
//  ViewController.swift
//  VKontakte GB
//
//  Created by Роберт on 04.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    //    MARK: LifyCycle
    
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let hideKeyBoardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyBoardGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWasShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,                      object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserDate()
        if !checkResult {
            showLoginError()
        }
        loginInput.text = ""
        passwordInput.text = ""
        return checkResult
    }
    
    @IBAction func unwindVC(unwind: UIStoryboardSegue) {}
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    @objc func keyBoardWasShow(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyBoardWillBeHidden(notification: Notification) {
        
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
}
private extension ViewController {
    func checkUserDate() -> Bool {
        guard
            let login = loginInput.text,
            let password = passwordInput.text
        else {
            return false
            
        }
        if login == "admin" && password == "1234" {
          return true
        } else {
           return false
        }
    }
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Введены неверные данные пользователя",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
