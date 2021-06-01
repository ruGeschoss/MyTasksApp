//
//  Composite.swift
//  MyTasks
//
//  Created by Alexander Andrianov on 01.06.2021.
//

import Foundation

protocol Composite {
  var taskDescription: String { get }
  var subTasks: [Composite] { get set }
  func getSubCount() -> Int
}
