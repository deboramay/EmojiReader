//
//  EmojiTableViewController.swift
//  EmojiReader
//
//  Created by Anastasia on 07.02.2022.
//

import UIKit

class EmojiTableViewController: UITableViewController {
  
  var objects = [
    Emoji(emoji: "🥰", name: "Love", description: "Let's love each other", isFavourite: false),
    Emoji(emoji: "⚽️", name: "Football", description: "Let's play football together", isFavourite: false),
    Emoji(emoji: "🐱", name: "Cat", description: "Cat is the cutest animal", isFavourite: false)
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = "Emoji Reader"
    self.navigationItem.leftBarButtonItem = self.editButtonItem
  }
  
  @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveSegue" else { return }
    let sourceVC = segue.source as! NewEmojiTableViewController
    let emoji = sourceVC.emoji
    
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      objects[selectedIndexPath.row] = emoji
      tableView.reloadRows(at: [selectedIndexPath], with: .fade)
    } else {
      let newIndexPath = IndexPath(row: objects.count, section: 0)
      objects.append(emoji)
      tableView.insertRows(at: [newIndexPath], with: .fade)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard segue.identifier == "editEmoji" else { return }
    let indexPath = tableView.indexPathForSelectedRow!
    let emoji = objects[indexPath.row]
    let navigationVC = segue.destination as! UINavigationController
    let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
    newEmojiVC.emoji = emoji
    newEmojiVC.title = "Edit"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return objects.count
  }
  
  //создаем таблицу
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
    let object = objects[indexPath.row]
    cell.set(object: object)
    return cell
  }
  
  //что происходит при нажатии на эдит
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  //удаление элементов через эдит
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      objects.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  //возможность перемещать строки
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  //как именно перемещать
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedEmoji = objects.remove(at: sourceIndexPath.row)
    objects.insert(movedEmoji, at: sourceIndexPath.row)
    tableView.reloadData()
  }
  
  //функции для свайпа слева
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let done = doneAction(at: indexPath)
    let favourite = favouriteAction(at: indexPath)
    return UISwipeActionsConfiguration(actions: [done, favourite])
  }
  
  //по свайпу слева "галочка"
  func doneAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "Done") { action, view, completion in
      self.objects.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      completion(true)
    }
    action.backgroundColor = .systemGreen
    action.image = UIImage(systemName: "checkmark.circle")
    return action
  }
  
  //по свайпу слева "сердечко"
  func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
    var object = objects[indexPath.row]
    let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completion) in
      object.isFavourite = !object.isFavourite
      self.objects[indexPath.row] = object
      completion(true)
    }
    action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
    action.image = UIImage(systemName: "heart")
    return action
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
