//: Playground - noun: a place where people can play

import UIKit

//MARK: Game related data structures

enum Player {
    case X
    case O
    case None
}

struct Coordinate {
    var x = 0
    var y = 0
    var claimedBy: Player
}

protocol Game {
    mutating func gameStart(withMove atCoordinate: Coordinate)
    mutating func executeMove(atCoordinate: Coordinate)
    func gameOver(withWinner player: Player)
}

//MARK: Initializing Game

struct GameGrid: Game {
    var xMax = 3
    var yMax = 3
    var winLength = 3
    var grid = [[Coordinate]]()
    
    init(xMax: Int = 3, yMax: Int = 3, winLength: Int = 3) {
        self.xMax = xMax
        self.yMax = yMax
        self.winLength = winLength
        for x in 0..<self.xMax {
            grid.append([Coordinate]())
            for y in 0..<self.yMax {
                grid[x].append(Coordinate(x: x, y: y, claimedBy: .None))
            }
        }
    }
}


//MARK - Implementing Game

extension GameGrid {
    
    mutating func gameStart(withMove atCoordinate: Coordinate) {
        self.executeMove(atCoordinate: atCoordinate)
    }
    
    mutating func executeMove(atCoordinate: Coordinate) {
        guard self.grid.indices.contains(atCoordinate.x)
            && self.grid.indices.indices.contains(atCoordinate.y) else {
            fatalError("\(atCoordinate) is out of range!")
        }
        self.grid[atCoordinate.x][atCoordinate.y].claimedBy = atCoordinate.claimedBy
        print(atCoordinate)
        if winnerForMove(atCoordinate: atCoordinate) {
            self.gameOver(withWinner: atCoordinate.claimedBy)
        }
  }
    
    func gameOver(withWinner player: Player) {
        var name = String()
        switch player {
        case .X:
            name = "X"
        case .O:
            name = "Y"
        case .None:
            name = "Nobody"
        }
        print("\(name) has won the game.")
    }
}

//MARK: win validation

extension GameGrid {
  
  func winnerForMove(atCoordinate: Coordinate) -> Bool {
    let startCoordinate = atCoordinate
    var verticalCount: Int = 0
    var winner = false
    // look up
    self.look0Degrees(fromCoordinate: startCoordinate, forPlayer: startCoordinate.claimedBy, count: &verticalCount)
    print(verticalCount)
    if verticalCount == 2 {
      winner = true
    }
    return winner
  }

  func look0Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if self.grid.indices.contains(x+1) {
      let nextCoordinate = self.grid[x+1][y]
      print(nextCoordinate)
      if nextCoordinate.claimedBy == player {
        count = count + 1
        look0Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look45Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
  
  func look90Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
  
  func look135Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
  
  func look180Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
  
  func look225Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
  
  func look315Degress(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    
  }
}

protocol GameGrideDelegate: class {
    func gameWon(atCoordinate: Coordinate)
}

var game = GameGrid(xMax: 3, yMax: 3, winLength: 3)
game.gameStart(withMove:  Coordinate(x: 2, y: 0, claimedBy: .X))
game.executeMove(atCoordinate: Coordinate(x: 1, y: 0, claimedBy: .X))
game.executeMove(atCoordinate: Coordinate(x: 0, y: 0, claimedBy: .X))


