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
  func claimedBy(player: Player) -> Bool {
    return self.claimedBy == player ? true : false
  }
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
    if winner(atCoordinate: atCoordinate) {
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
  
  func winner(atCoordinate: Coordinate) -> Bool {
    let startCoordinate    = atCoordinate
    var verticalCount      = 1
    var horizontalCount    = 1
    var angle45By225Count  = 1
    var angle135By315Count = 1
    var winner = false
    let currentPlayer = startCoordinate.claimedBy
    
    // look in all directions from the start coordinate for our current player to determin if this move was a winning move. This could be further simplified
    self.look0Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &horizontalCount)
    self.look45Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &angle45By225Count)
    self.look90Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &verticalCount)
    self.look135Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &angle135By315Count)
    self.look180Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &horizontalCount)
    self.look225Degrees(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &angle45By225Count)
    self.look315Degress(fromCoordinate: startCoordinate, forPlayer: currentPlayer, count: &angle135By315Count)
    
    if verticalCount == winLength
      || horizontalCount == winLength
      || angle45By225Count == winLength
      || angle135By315Count == winLength {
      winner = true
    }
    return winner
  }
  
  func look0Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x+1)
      && grid[x+1].indices.contains(y) {
      let nextCoordinate = self.grid[x+1][y]
      print(nextCoordinate)
      if nextCoordinate.claimedBy == player {
        count = count + 1
        look0Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look45Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x+1)
      && grid[x+1].indices.contains(y+1) {
      let nextCoordinate = grid[x+1][y+1]
      print(nextCoordinate)
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look45Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look90Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x)
      && grid[x].indices.contains(y-1) {
      let nextCoordinate  = grid[x][y-1]
      print(nextCoordinate)
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look90Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look135Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x-1)
      && grid[x-1].indices.contains(y-1) {
      let nextCoordinate = grid[x-1][y-1]
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look135Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look180Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x-1)
      && grid[x-1].indices.contains(y) {
      let nextCoordinate = grid[x-1][y]
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look180Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look225Degrees(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x-1)
      && grid[x-1].indices.contains(y-1) {
      let nextCoordinate = grid[x-1][y-1]
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look225Degrees(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
  
  func look315Degress(fromCoordinate: Coordinate, forPlayer player: Player, count: inout Int) {
    let x = fromCoordinate.x
    let y = fromCoordinate.y
    if grid.indices.contains(x+1) && grid[x+1].indices.contains(y+1) {
      let nextCoordinate = grid[x+1][y+1]
      if nextCoordinate.claimedBy(player: player) {
        count = count + 1
        look315Degress(fromCoordinate: nextCoordinate, forPlayer: player, count: &count)
      }
    }
  }
}

protocol GameGrideDelegate: class {
  func winner(atCoordinate: Coordinate, withGrid: GameGrid)
}

var game = GameGrid(xMax: 3, yMax: 3, winLength: 3)
game.gameStart(withMove:  Coordinate(x: 2, y: 0, claimedBy: .X))
game.executeMove(atCoordinate: Coordinate(x: 2, y: 1, claimedBy: .X))
game.executeMove(atCoordinate: Coordinate(x: 2, y: 2, claimedBy: .X))

