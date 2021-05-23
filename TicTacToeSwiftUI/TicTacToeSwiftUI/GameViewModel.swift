//
//  GameViewModel.swift
//  TicTacToeSwiftUI
//
//  Created by Aishat Olowoshile on 5/23/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    //@State private var isHumansTurn = true isHumanTurn.toggle()
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [0,1,2], [2,5,8], [0,4,8], [2,4,6]]
        
        let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer}
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvaliable = isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable { return winPositions.first! }
            }
        }
        
        //If AI can't win, then block
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human}
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvaliable = isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable { return winPositions.first! }
            }
        }
        
        //If AI cant block the take middle quare
        let middleSquare = 4
        if !isSquareOccupied(in: moves, forIndex: middleSquare) {
            return middleSquare
        }
        
        
        //If AI cant take middle position, then take randdom square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    
    func checkForWinCondition(for player: Player, in moves: [Move?])  -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [0,1,2], [2,5,8], [0,4,8], [2,4,6]]
        
        //parsing array
        //compactMap to remove nilS & filre by player type
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player}
        //map to only get board indexes
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?])  -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGameBoard() {
        //reset move array
        moves = Array(repeating: nil, count: 9)
    }
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        //check for win or draw
        if checkForWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        //check for draw
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        
        //computer move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkForWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
            }
            
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
        
    }
}
