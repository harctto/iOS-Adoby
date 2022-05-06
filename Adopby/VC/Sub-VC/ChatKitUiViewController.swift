//
//  ChatKitUiViewController.swift
//  Adopby
//
//  Created by Hatto on 1/5/2565 BE.
//

import UIKit
import CometChatPro
import Alamofire

class ChatKitUiViewController: CometChatConversationList {
    
    var uid:String = ""
    let authKey = "5dcab8f18ef25a578d00667cdbede748b0c85d6d"
    var currentUsername:Users!
    
    func setUpChat() {
        CometChat.login(UID: currentUsername.uid, apiKey: authKey, onSuccess: { (user) in
            print("Login successfull: " + user.stringValue())
            self.openChat()
        }) { (error) in
            print("Login failed with error" + error.errorDescription)
        }
    }
    
    func openChat() {
        DispatchQueue.main.async {
            let conversationList = CometChatConversationList()
            conversationList.set(title:"Chats", mode: .automatic)
            UIKitSettings.primaryColor = .init(rgb: 0x7E6514)
            UIKitSettings.chatListMode = .user
            UIKitSettings.backgroundColor = .init(rgb: 0xF7D154)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let valueTabbar = tabBarController as! BaseTabbar
        let url = "https://adoby.glitch.me/auth/\(valueTabbar.userData[0])"
        DispatchQueue.main.async {
            AF.request(
                url,
                method: .get
            ).responseDecodable(of: Users.self) { response in
                self.currentUsername = response.value
                self.setUpChat()
            }
        }
    }
    
}

extension ChatKitUiViewController: ConversationListDelegate {
    func didSelectConversationAtIndexPath(conversation: Conversation, indexPath: IndexPath) {
        print(conversation)
    }
}
