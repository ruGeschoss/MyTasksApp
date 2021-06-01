//
//  CompositeTask.swift
//  MyTasks
//
//  Created by Alexander Andrianov on 01.06.2021.
//

import Foundation

final class CompositeTask: Composite {
  var taskDescription: String
  var subTasks: [Composite]
  
  init(description: String?) {
    self.taskDescription = description ?? ""
    self.subTasks = []
  }
  
  func getSubCount() -> Int {
    subTasks.reduce(0) { $0 + $1.subTasks.count + $1.getSubCount() }
  }
  
}
