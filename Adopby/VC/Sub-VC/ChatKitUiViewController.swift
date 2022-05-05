//
//  ChatKitUiViewController.swift
//  Adopby
//
//  Created by Hatto on 1/5/2565 BE.
//

import UIKit
import CometChatPro

class ChatKitUiViewController: CometChatConversationList {
    
    var uid:String = ""
    let authKey = "5dcab8f18ef25a578d00667cdbede748b0c85d6d"
    var currentUsername:[String] = []
    
    func setUpChat() {
        CometChat.login(UID: currentUsername[0], apiKey: authKey, onSuccess: { (user) in
            print("Login successfull: " + user.stringValue())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.openChat()
            }
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
        let valueTabbar = tabBarController as! BaseTabbar
        currentUsername = valueTabbar.userData
        uid = currentUsername[0]
        self.LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.setUpChat()
            self.LoadingStop()
        }
        
        // Do any additional setup after loading the view.
    }
    
}

extension ChatKitUiViewController: ConversationListDelegate {
    func didSelectConversationAtIndexPath(conversation: Conversation, indexPath: IndexPath) {
        print(conversation)
    }
}
