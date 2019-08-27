//
//  PostController.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    // MARK: - Crud Functions
    
    func addComment(text: String, post: Post, completion: (Comment) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: (Post?) -> Void) {
        let post = Post(photo: image, caption: caption)
        posts.append(post)
    }
}
