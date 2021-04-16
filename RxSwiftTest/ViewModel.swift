//
//  ViewModel.swift
//  RxSwiftTest
//
//  Created by ParkJonghyun on 2021/04/16.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Input
    associatedtype Output
    
    var dependency: Dependency { get }
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    
    init(dependency: Dependency)
    
}

class ViewModel: ViewModelType {
    
    struct Dependency {
        var name:String?
        var email: String?
        
    }
    
    struct  Input {
        var nameText: AnyObserver<String?>
        var emailText: AnyObserver<String?>
        
    }
    
    struct Output {
        var name: Observable<String?>
        var email: Observable<String?>
        var isConfirmEnabled: Driver<Bool>
    }
    
    let dependency: Dependency
    var disposeBag: DisposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let nameText$: BehaviorSubject<String?>
    private let emailText$: BehaviorSubject<String?>
    
    required init(dependency: Dependency = Dependency(name: nil, email: nil)) {
        self.dependency = dependency

        // Streams
        let nameText$ = BehaviorSubject<String?>(value: nil)
        let emailText$ = BehaviorSubject<String?>(value: nil)
        
        let isConfirmEnabled$ = Observable.combineLatest(nameText$, emailText$)
            .map(validation)
            .asDriver(onErrorJustReturn: false)
        
        // Input & Output
        self.input = Input(nameText: nameText$.asObserver(),
                           emailText: emailText$.asObserver())
        self.output = Output(name: nameText$, email: emailText$, isConfirmEnabled: isConfirmEnabled$)
        
        // Binding
        self.nameText$ = nameText$
        self.emailText$ = emailText$
    }
    
    
    
}

private func validation(name: String?, email: String?) -> Bool {
    return name?.isEmpty == false && email?.isEmpty == false
}



