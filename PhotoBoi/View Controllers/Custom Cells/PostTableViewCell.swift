//
//  PostTableViewCell.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    // MARK: - Properties
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        guard let post = post else {return}
        
        postImage.image = post.photo
        postCaptionLabel.text = post.caption
        postCommentsLabel.text = String(post.commentCount)
        
        var commentsString = ""
        for comment in post.comments {
            commentsString += comment.text + "\n\n"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
