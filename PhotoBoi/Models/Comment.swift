//
//  Comment.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

struct CommentConstants {
    
    static let recordTypeKey = "Comment"
    static let recordTextKey = "text"
    static let recordTimestampKey = "timestamp"
    static let recordReferenceKey = "reference"
}

class Comment {
    
    let text: String
    let timestamp: Date
    weak var post: Post?
    var recordID: CKRecord.ID
    var reference: CKRecord.Reference? {
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
}

extension Comment {
    convenience init?(record: CKRecord, post: Post) {
        guard let text = record[CommentConstants.recordTextKey] as? String,
        let timestamp = record[CommentConstants.recordTimestampKey] as? Date else {return nil}
        self.init(text: text, timestamp: timestamp, post: post, recordID: record.recordID)
        
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if text.contains(searchTerm) {
            return true
        } else {
            return false
        }
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        let recordID = comment.recordID
        self.init(recordType: CommentConstants.recordTypeKey, recordID: recordID)
        self.setValue(comment.text, forKey: CommentConstants.recordTextKey)
        self.setValue(comment.timestamp, forKey: CommentConstants.recordTimestampKey)
        self.setValue(comment.reference, forKey: CommentConstants.recordReferenceKey)
    }
}
