//
//  GameView.swift
//  TicTacToeSwiftUI
//
//  Created by Aishat Olowoshile on 5/20/21.
//

import SwiftUI


struct GameView: View {
    
   @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        //geometry UI for dynamic screen sizes
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            //circle first
                            GameCircleView(proxy: geometry)
                            //then image
                            PlayerIndicator(systemmImageName: viewModel.moves[i]?.indicator ?? "")
                            
                        }.onTapGesture {
                            viewModel.processPlayerMove(for: i)
                    }
                }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGameBoard() }))
                
            })
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameCircleView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.8)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    var systemmImageName: String
    
    var body: some View {
        Image(systemName: systemmImageName)
            .resizable()
            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

