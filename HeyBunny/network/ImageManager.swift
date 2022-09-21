//
//  ImageManager.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import Foundation

final class ImageManager {
    private init() { }
    static let shared = ImageManager()
    let cachedImages = NSCache<NSString, NSData>()
    func fetchImage(from url: URL) async throws -> Data {
        if let data = checkCache(url: url) {
            return data
        } else {
            try await imageDiskCache(from: url)
        }
        guard let cacheData = bringDataFromCache(url: url) else {
            return Data()
        }
        return cacheData
    }
    
    private func imageDiskCache(from url: URL) async throws {
        let downloadLocation = try await URLSession.shared.download(from: url).0
        let fileManager = FileManager.default
        let tempPath = downloadLocation.path
        let imageName = url.lastPathComponent 
        
        guard let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        let finalPath = cacheDirectoryPath + "/" + imageName
        
        try? fileManager.moveItem(atPath: tempPath, toPath: finalPath)
        
        var filePath = URL(fileURLWithPath: cacheDirectoryPath)
        filePath.appendPathComponent(imageName)
        
        if fileManager.fileExists(atPath: finalPath) {
            guard let imageNSData = NSData(contentsOf: filePath) else { return }
            cachedImages.setObject(imageNSData, forKey: NSString(string: imageName))
        }
    }
    
    private func checkCache(url: URL) -> Data? {
        let imageName = url.lastPathComponent 
        // CheckMemory
        if let imageData = bringDataFromCache(url: url) {
            return Data(imageData)
        }

        // CheckDisk
        if let imageNSData = findDataInDiskMemory(from: url) {
            //만약 Cache의 Value값이 NSData가 아닌 다른 값이라면 여기서 변환을 해서 넣어줌.
            cachedImages.setObject(imageNSData, forKey: imageName as NSString)
            return imageNSData as Data?
        }
        return nil
    }
    
    private func findDataInDiskMemory(from url: URL) -> NSData? {
        let fileManager = FileManager()
        let imageName = url.lastPathComponent 
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(imageName)
        
        if fileManager.fileExists(atPath: filePath.path) {
            let imageData = NSData(contentsOf: filePath)
            return imageData
        }
        return nil
    }
    
    private func bringDataFromCache(url: URL) -> Data? {
        return cachedImages.object(forKey: NSString(string: url.lastPathComponent )) as Data?
    }
}
