//
//  ViewController.swift
//  authentication
//
//  Created by Sam Sung on 2023/05/03.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var kakaoTalkAuthButton: UIButton!
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(#function)
    }
    
    @IBAction func handleAppleButton(_ sender: Any) {
        print(#function)
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
}

