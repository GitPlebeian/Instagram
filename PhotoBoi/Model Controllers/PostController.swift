//
//  PostController.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Crud Functions
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        let commentRecord = CKRecord(comment: comment)
        publicDB.save(commentRecord) { (record, error) in
            if let error = error {
                print("Error at \(#function)\nBig Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let record = record, let comment = Comment(record: record, post: post) else {completion(nil); return}
            post.commentCount += 1
            self.updateForPost(post: post)
            completion(comment)
        }
    }
    
    func updateForPost(post: Post) {
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.queuePriority = .veryHigh
        modificationOP.qualityOfService = .userInitiated
        
        publicDB.add(modificationOP)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: image, caption: caption)
        let postRecord = CKRecord(post: post)
        publicDB.save(postRecord) { (record, error) in
            if let error = error {
                print("Error at \(#function)\nBig Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record, let post = Post(ckRecord: record) else {completion(nil); return}
            self.posts.append(post)
            completion(post)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error at \(#function)\nBig Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil); return}
            
            let posts = records.compactMap({Post(ckRecord: $0)})
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postReference = post.recordID
        let predicateOne = NSPredicate(format: "%K == %@", CommentConstants.recordReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicateTwo = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOne, predicateTwo])
        let query = CKQuery(recordType: CommentConstants.recordTypeKey, predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error at \(#function)\nBig Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil); return}
            
            let comments = records.compactMap({Comment(record: $0, post: post)})
            for comment in comments {
                post.comments.append(comment)
            }
            completion(comments)
        }
    }
}
