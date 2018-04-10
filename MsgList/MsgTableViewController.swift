//
//  MsgTableViewController.swift
//  MsgList
//
//  Created by Anna Dickinson on 4/9/18.
//  Copyright © 2018 Anna Dickinson. All rights reserved.
//

import UIKit
import AlamofireImage

private let testFileName = "messages"
private let testFileExtension = "json"

private let msgCellID = "MsgTableViewCell"
private let msgSectionHeaderID = "MsgTableViewSectionHeader"

private let msgDateFormatter: DateFormatter = {
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateStyle = .short
    newDateFormatter.timeStyle = .none
    newDateFormatter.doesRelativeDateFormatting = true
    return newDateFormatter
}()

private let headerDateFormatter: DateFormatter = {
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "MMM dd"
    return newDateFormatter
}()

class MsgTableViewController: UITableViewController {
    var messages: [Message] = []
    var messageIndiciesByDay: [[Int]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: msgSectionHeaderID, bundle: nil), forHeaderFooterViewReuseIdentifier: msgSectionHeaderID)
        
        // In a real-world application, this error handling would be more robust (obviously)
        guard let testFileURL = Bundle.main.url(forResource: testFileName, withExtension: testFileExtension) else {
            fatalError("Could not read \(testFileName).\(testFileExtension)")
        }
        
        do {
            try messages = MessageData.messages(from: testFileURL)
        }
        catch {
            log.error("Invalid JSON message test file.\n\(error)")
        }
        
        // Group into sections by unique days
        if messages.isEmpty {
            return
        }

        if messages.count == 1 {
            messageIndiciesByDay[0][0] = 0
            return
        }
        
        var sectionIndex = 0
        for messageIndex in 1..<messages.count {
            let currElement = messages[messageIndex]
            let prevElement = messages[messageIndex - 1]
            if DayMonth(date: currElement.created) != DayMonth(date: prevElement.created) {
                messageIndiciesByDay.append([])
                sectionIndex = sectionIndex + 1
            }
            messageIndiciesByDay[sectionIndex].append(messageIndex)
        }
    }

    func message(for indexPath: IndexPath) -> Message {
        return messages[messageIndiciesByDay[indexPath.section][indexPath.row]]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messageIndiciesByDay.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageIndiciesByDay[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: msgCellID, for: indexPath) as? MsgTableViewCell else {
            fatalError("Could not dequeue cell as MsgTableViewCell")
        }

        let msg = message(for: indexPath)
        
        cell.avatarImageView.af_setImage(withURL: msg.user.imageURL) {
            response in
            if case .failure = response.result {
                // In a real-world application, we'd probably display a broken image icon here.
                
                let codeString: String
                if let code = response.response?.statusCode {
                    codeString = "\(code)"
                }
                else {
                    codeString = "<unknown>"
                }
                let urlString = response.request?.url?.description ?? "<unknown>"
                log.error("Image fetch failed. URL: \(urlString) code: \(codeString)")
            }
        }
        
        cell.contentLabel.text = msg.content
        cell.nameLabel.text = msg.user.displayName
        cell.dateLabel.text = msgDateFormatter.string(from: msg.created)

        if indexPath.row > 0 {
            let prevMsg = message(for: IndexPath(row: indexPath.row - 1, section: indexPath.section))
            cell.firstInSequence = prevMsg.user != msg.user
        }
        else {
            cell.firstInSequence = true
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: msgSectionHeaderID) as? MsgTableViewSectionHeader else {
            log.error("Could not dequeue header as MsgTableViewSectionHeader")
            return nil
        }

        let firstMessageInSection = message(for: IndexPath(row: 0, section: section))
        header.dateLabel.text = headerDateFormatter.string(from: firstMessageInSection.created).uppercased()

        return header
    }
}

