//
//  TasksViewController.swift
//  MyTasks
//
//  Created by Alexander Andrianov on 01.06.2021.
//

import UIKit

final class TasksViewController: UIViewController {
  
  private enum Constants {
    static let addTaskImage = UIImage(systemName: "plus")
    static let rootControllerImage = UIImage(systemName: "house")
  }
  
  private enum AlertConstants {
    static let title = "Add task"
    static let message = "Enter task name"
    static let cancelTitle = "Cancel"
    static let saveTitle = "Save"
  }
  
  private var tableView: UITableView {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }
  
  private var addTaskButton: UIBarButtonItem {
    let button = UIBarButtonItem()
    button.target = self
    button.action = #selector(addTask)
    button.image = Constants.addTaskImage
    return button
  }
  
  private var goToRootButton: UIBarButtonItem {
    let button = UIBarButtonItem()
    button.target = self
    button.action = #selector(goToRootVC)
    button.image = Constants.rootControllerImage
    return button
  }
  
  private lazy var addTaskAlert: UIAlertController = {
    var alert = UIAlertController(title: AlertConstants.title,
                                  message: AlertConstants.message,
                                  preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    let cancel = UIAlertAction(title: AlertConstants.cancelTitle,
                               style: .cancel)
    let save = UIAlertAction(title: AlertConstants.saveTitle,
                             style: .default) { [weak self] _ in
      let text = alert.textFields?.first?.text
      let newTask = CompositeTask(description: text)
      self?.task.subTasks.append(newTask)
      self?.reloadTableViewData()
    }
    alert.addAction(cancel)
    alert.addAction(save)
    return alert
  }()
  
  private var task: Composite
  
  override func loadView() {
    view = tableView
  }
  
  init(task: Composite) {
    self.task = task
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadTableViewData()
  }
  
  @objc private func addTask() {
    addTaskAlert.textFields?.first?.text = .none
    present(addTaskAlert, animated: true)
  }
  
  @objc private func goToRootVC() {
    navigationController?.popToRootViewController(animated: true)
  }
  
}

extension TasksViewController {
  
  private func reloadTableViewData() {
    guard let view = view as? UITableView else { return }
    view.reloadData()
  }
  
  private func setupNavigationController() {
    navigationItem.title = task.taskDescription
    navigationItem.rightBarButtonItem = addTaskButton
    navigationItem.leftItemsSupplementBackButton = true
    
    if navigationController?.viewControllers.first != self {
      navigationItem.leftBarButtonItem = goToRootButton
    }
  }
  
}

extension TasksViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedTask = task.subTasks[indexPath.row]
    let viewController = TasksViewController(task: selectedTask)
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}

extension TasksViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    task.subTasks.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let subTask = task.subTasks[indexPath.row]
    let subtasksCount = task.getSubCount()
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "TaskCell")
    cell.selectionStyle = .none
    cell.textLabel?
      .text = "\(subTask.taskDescription)"
    if subtasksCount != .zero {
      cell.detailTextLabel?
        .text = "Subtasks: \(task.getSubCount())"
    }
    return cell
  }
  
}
