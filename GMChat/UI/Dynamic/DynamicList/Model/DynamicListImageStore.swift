//
//  DynamicListImageStore.swift
//  GMChat
//
//  Created by GXT on 2019/7/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

class DynamicListImageStore {
    static let shared = DynamicListImageStore()
    /// 缓存裁剪后的图片
    /// 动态发布者的头像
    lazy var listUserHeaderDic: [String: UIImage] = [String: UIImage]()
    /// 动态图片
    lazy var listImageDic: [String: UIImage] = [String: UIImage]()
    /// 点赞者的头像
    lazy var likesUserHeaderDic: [String: UIImage] = [String: UIImage]()
    /// 评论者头像
    lazy var commentsUserHeaderDic: [String: UIImage] = [String: UIImage]()
    /// 相册选取的图片
    lazy var localImagesDic: [String: UIImage] = [String: UIImage]()
}
