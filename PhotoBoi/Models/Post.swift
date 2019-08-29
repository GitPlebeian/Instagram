//
//  Post.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct PostConstants {
    static let recordTypeKey = "Post"
    static let recordCaptionKey = "caption"
    static let recordTimestampKey = "timestamp"
    static let recordPhotoKey = "photo"
}

class Post {
    
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.photo = photo
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        }
        for comment in comments {
            if comment.matches(searchTerm: searchTerm) {
                return true
            }
        }
        return false
    }
}

extension CKRecord {
    convenience init?(post: Post) {
        self.init(recordType: PostConstants.recordTypeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: PostConstants.recordCaptionKey)
        self.setValue(post.timestamp, forKey: PostConstants.recordTimestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.recordPhotoKey)
    }
}

extension Post {
    // Creating a hype from a record
    // Failable because of network conecctivity issues
    convenience init?(ckRecord: CKRecord) {
        guard let postCaption = ckRecord[PostConstants.recordCaptionKey] as? String,
            let postTimestamp = ckRecord[PostConstants.recordTimestampKey] as? Date,
            let postImageAsset = ckRecord[PostConstants.recordPhotoKey] as? CKAsset,
            let postImageFileURL = postImageAsset.fileURL else {return nil}
        
        do {
            let data = try Data(contentsOf: postImageFileURL)
            guard let postImage = UIImage(data: data) else {return nil}
            self.init(photo: postImage, caption: postCaption, timestamp: postTimestamp, comments: [], recordID: ckRecord.recordID)
            
        } catch {
            print("Error at \(#function) \(error) \(error.localizedDescription)")
            return nil
        }
    }
}

//extension Hype: Equatable {
//    static func ==(lhs: Hype, rhs: Hype) -> Bool {
//        return lhs.text == rhs.text &&
//            lhs.timestamp == rhs.timestamp &&
//            lhs.ckRecordID == rhs.ckRecordID
//    }
//}
