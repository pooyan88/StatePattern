//
//  PostCell.swift
//  StatePattern
//
//  Created by Pooyan J on 3/17/1404 AP.
//

import UIKit

class PostCell: UITableViewCell {

    static func getHeight() -> CGFloat {
        let topLabelHeight: CGFloat = 44
        return topLabelHeight + heightOfTitle
    }

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    static var heightOfTitle: CGFloat = 0

    struct Config {
        var id: Int
        var title: String
    }
}

// MARK: - Setup Functions
extension PostCell {

    func setup(config: Config) {
        idLabel.text = "\(config.id)"
        bodyLabel.text = config.title
        PostCell.heightOfTitle = heightForText(config.title, font: .systemFont(ofSize: 17), width: UIScreen.main.bounds.width - 32)

    }

     func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }

}
