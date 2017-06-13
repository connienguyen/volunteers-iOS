// MARK: - Mocks generated from file: VOLA/LoginManager.swift at 2017-06-13 07:02:53 +0000

//
//  LoginManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Cuckoo
@testable import VOLA

import FBSDKLoginKit
import Foundation

class MockLoginManager: LoginManager, Cuckoo.Mock {
    typealias MocksType = LoginManager
    typealias Stubbing = __StubbingProxy_LoginManager
    typealias Verification = __VerificationProxy_LoginManager
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: LoginManager?

    func spy(on victim: LoginManager) -> Self {
        observed = victim
        return self
    }

     override func login(user: User)  {
        
        return cuckoo_manager.call("login(user: User)",
            parameters: (user),
            original: observed.map { o in
                return { (user: User) in
                    o.login(user: user)
                }
            })
        
    }
    
     override func logOut()  {
        
        return cuckoo_manager.call("logOut()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.logOut()
                }
            })
        
    }
    
     override func loginFacebook(completion: @escaping ErrorCompletionBlock)  {
        
        return cuckoo_manager.call("loginFacebook(completion: @escaping ErrorCompletionBlock)",
            parameters: (completion),
            original: observed.map { o in
                return { (completion: @escaping ErrorCompletionBlock) in
                    o.loginFacebook(completion: completion)
                }
            })
        
    }
    
     override func loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock)  {
        
        return cuckoo_manager.call("loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock)",
            parameters: (notification, completion),
            original: observed.map { o in
                return { (notification: NSNotification, completion: @escaping ErrorCompletionBlock) in
                    o.loginGoogle(notification: notification, completion: completion)
                }
            })
        
    }
    
     override func signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock)  {
        
        return cuckoo_manager.call("signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock)",
            parameters: (name, email, password, completion),
            original: observed.map { o in
                return { (name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock) in
                    o.signUpManual(name: name, email: email, password: password, completion: completion)
                }
            })
        
    }
    
     override func loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock)  {
        
        return cuckoo_manager.call("loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock)",
            parameters: (email, password, completion),
            original: observed.map { o in
                return { (email: String, password: String, completion: @escaping ErrorCompletionBlock) in
                    o.loginManual(email: email, password: password, completion: completion)
                }
            })
        
    }
    
     override func updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock)  {
        
        return cuckoo_manager.call("updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock)",
            parameters: (name, email, completion),
            original: observed.map { o in
                return { (name: String, email: String, completion: @escaping ErrorCompletionBlock) in
                    o.updateUser(name: name, email: email, completion: completion)
                }
            })
        
    }
    

    struct __StubbingProxy_LoginManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func login<M1: Cuckoo.Matchable>(user: M1) -> Cuckoo.StubNoReturnFunction<(User)> where M1.MatchedType == User {
            let matchers: [Cuckoo.ParameterMatcher<(User)>] = [wrap(matchable: user) { $0 }]
            return .init(stub: cuckoo_manager.createStub("login(user: User)", parameterMatchers: matchers))
        }
        
        func logOut() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("logOut()", parameterMatchers: matchers))
        }
        
        func loginFacebook<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.StubNoReturnFunction<(ErrorCompletionBlock)> where M1.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(ErrorCompletionBlock)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub("loginFacebook(completion: @escaping ErrorCompletionBlock)", parameterMatchers: matchers))
        }
        
        func loginGoogle<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(notification: M1, completion: M2) -> Cuckoo.StubNoReturnFunction<(NSNotification, ErrorCompletionBlock)> where M1.MatchedType == NSNotification, M2.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(NSNotification, ErrorCompletionBlock)>] = [wrap(matchable: notification) { $0.0 }, wrap(matchable: completion) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock)", parameterMatchers: matchers))
        }
        
        func signUpManual<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(name: M1, email: M2, password: M3, completion: M4) -> Cuckoo.StubNoReturnFunction<(String, String, String, ErrorCompletionBlock)> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, ErrorCompletionBlock)>] = [wrap(matchable: name) { $0.0 }, wrap(matchable: email) { $0.1 }, wrap(matchable: password) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock)", parameterMatchers: matchers))
        }
        
        func loginManual<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(email: M1, password: M2, completion: M3) -> Cuckoo.StubNoReturnFunction<(String, String, ErrorCompletionBlock)> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, ErrorCompletionBlock)>] = [wrap(matchable: email) { $0.0 }, wrap(matchable: password) { $0.1 }, wrap(matchable: completion) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock)", parameterMatchers: matchers))
        }
        
        func updateUser<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(name: M1, email: M2, completion: M3) -> Cuckoo.StubNoReturnFunction<(String, String, ErrorCompletionBlock)> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, ErrorCompletionBlock)>] = [wrap(matchable: name) { $0.0 }, wrap(matchable: email) { $0.1 }, wrap(matchable: completion) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_LoginManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        @discardableResult
        func login<M1: Cuckoo.Matchable>(user: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == User {
            let matchers: [Cuckoo.ParameterMatcher<(User)>] = [wrap(matchable: user) { $0 }]
            return cuckoo_manager.verify("login(user: User)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func logOut() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("logOut()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loginFacebook<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(ErrorCompletionBlock)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify("loginFacebook(completion: @escaping ErrorCompletionBlock)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loginGoogle<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(notification: M1, completion: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSNotification, M2.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(NSNotification, ErrorCompletionBlock)>] = [wrap(matchable: notification) { $0.0 }, wrap(matchable: completion) { $0.1 }]
            return cuckoo_manager.verify("loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func signUpManual<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(name: M1, email: M2, password: M3, completion: M4) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, ErrorCompletionBlock)>] = [wrap(matchable: name) { $0.0 }, wrap(matchable: email) { $0.1 }, wrap(matchable: password) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return cuckoo_manager.verify("signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loginManual<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(email: M1, password: M2, completion: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, ErrorCompletionBlock)>] = [wrap(matchable: email) { $0.0 }, wrap(matchable: password) { $0.1 }, wrap(matchable: completion) { $0.2 }]
            return cuckoo_manager.verify("loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func updateUser<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(name: M1, email: M2, completion: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == ErrorCompletionBlock {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, ErrorCompletionBlock)>] = [wrap(matchable: name) { $0.0 }, wrap(matchable: email) { $0.1 }, wrap(matchable: completion) { $0.2 }]
            return cuckoo_manager.verify("updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class LoginManagerStub: LoginManager {

     override func login(user: User)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func logOut()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func loginFacebook(completion: @escaping ErrorCompletionBlock)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



