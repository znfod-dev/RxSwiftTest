//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by ParkJonghyun on 2021/04/16.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.bind()
        
    }
    
    func initUI() {
        self.nameTF.delegate = self
        self.emailTF.delegate = self
    }
    
    private func bind() {
        nameTF.rx.text.bind(to: viewModel.input.nameText).disposed(by: disposeBag)
        emailTF.rx.text.bind(to: viewModel.input.emailText).disposed(by: disposeBag)
        
        
        viewModel.output.name.bind(to: nameLbl.rx.text).disposed(by: disposeBag)
        viewModel.output.email.bind(to: emailLbl.rx.text).disposed(by: disposeBag)
        viewModel.output.isConfirmEnabled.drive(confirmBtn.rx.isEnabled).disposed(by: disposeBag)
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

