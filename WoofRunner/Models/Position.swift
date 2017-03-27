//
//  Position.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
 Indicates a position on our game grid
 */
public struct Position {
    private let row: Int;
    private let col: Int;
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    func getRow() -> Int {
        return self.row
    }
    
    func getCol() -> Int {
        return self.col
    }
}
