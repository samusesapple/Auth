//
//  ViewController.swift
//  authentication
//
//  Created by Sam Sung on 2023/05/03.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon


class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var kakaoTalkAuthButton: UIButton!
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    

    // MARK: - Actions
    @IBAction func handleKakaoButton(_ sender: Any) {
        // 카카오톡 공유 가능한 상태 (카카오 설치된 상태면 실행)
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print(#function)

                    //do something
                    _ = oauthToken
                    self.setUserInfo()
                }
            }
        }
    }
    
    @IBAction func handleGoogleButton(_ sender: Any) {
        let config = GIDConfiguration(clientID: "1084177995176-u7e6m7mud1fvtbtjdodcquoef80iatl3.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.signOut()
            self.userNameLabel.text = "구글 로그아웃 완료"
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] user, error in
            if let error = error { print(error); return }
            self?.userNameLabel.text = user?.user.profile?.name
        }
    }
    
    @IBAction func handleAppleButton(_ sender: Any) {
        // 요청 만들기
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // 요청하는 컨트롤러 생성
        let appleAuthController = ASAuthorizationController(authorizationRequests: [request])
        // Delegate 채택
        appleAuthController.delegate = self
        //
        appleAuthController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        // 유저에게 요청 보내기
        appleAuthController.performRequests()
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        logoutKakaoTalk()
    }
    
    // MARK: - Helpers
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("me() success")
                        self.userNameLabel.text = user?.kakaoAccount?.profile?.nickname
                    }
                }
            }
    
    func logoutKakaoTalk() {
        UserApi.shared.logout {(error) in
            if let error = error {
                self.userNameLabel.text = "카카오 로그인 정보 없음"
                print(error)
            }
            else {
                self.userNameLabel.text = "카카오톡 로그아웃 완료"
                print("카톡 로그아웃 성공")
            }
        }
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate {
    // 성공한 경우 동작하는 코드
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            // 로그인 후 유저 정보 ASAuthorizationAppleIDCredential 타입으로 타입캐스팅 (애플 로그인이므로)
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            if let fullName = credential.fullName {
                userNameLabel.text = fullName.givenName
            }
        }
        
        // 실패한 경우 동작하는 코드
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("애플 로그인 실패")
        }
}
