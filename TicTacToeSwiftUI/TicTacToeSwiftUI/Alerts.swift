//
//  Alerts.swift
//  TicTacToeSwiftUI
//
//  Created by Aishat Olowoshile on 5/23/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("You are so smart. You beat the AI."),
                             buttonTitle: Text("YASS"))
    
    static let computerWin = AlertItem(title: Text("You Lost :("),
                             message: Text("Yoou programmed a super AI"),
                             buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("Tough battle"),
                             buttonTitle: Text("Try Again"))
}
