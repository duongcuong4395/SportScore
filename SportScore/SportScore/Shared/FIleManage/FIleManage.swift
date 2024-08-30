//
//  FIleManage.swift
//  SportScore
//
//  Created by pc on 30/07/2024.
//

import Foundation

protocol FileManaging {
    func load<T: Decodable>(by path: String) -> T?
    func load<T: Decodable>(by path: String, completion: @escaping (T?) -> Void)

}

class FileManage: FileManaging {
    private let fileManager = FileManager.default
    private let trafficDirectory: URL
    
    init() {
            // Xác định đường dẫn tới thư mục Resource/Traffic trong bundle
            if let bundlePath = Bundle.main.resourcePath {
                // Tạo URL cho thư mục Traffic
                trafficDirectory = URL(fileURLWithPath: bundlePath).appendingPathComponent("Resources/Traffic")
            } else {
                fatalError("Resource path not found")
            }
        }
    
    func load<T: Decodable>(by path: String) -> T? {
        guard let fileURL = Bundle.main.url(forResource: path, withExtension: nil),
               let data = try? Data(contentsOf: fileURL),
              
               let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            
            print("load.path", path, T.self)
                    return nil
                }
         return decodedData
    }
    
   
    static func loadByStream<T: Decodable>(fromFileAt url: URL, completion: @escaping ([T]) -> Void) {
            guard let inputStream = InputStream(url: url) else {
                print("Failed to open input stream")
                completion([])
                return
            }
            
            inputStream.open()
            
            defer {
                inputStream.close()
            }
            
            var data = Data()
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            
            defer {
                buffer.deallocate()
            }
            
            var busRoutes: [T] = []
            
            while inputStream.hasBytesAvailable {
                let bytesRead = inputStream.read(buffer, maxLength: bufferSize)
                guard bytesRead >= 0 else {
                    print("Failed to read stream")
                    completion([])
                    return
                }
                
                data.append(buffer, count: bytesRead)
            }
            
            do {
                let decodedData = try JSONDecoder().decode([T].self, from: data)
                busRoutes = decodedData
            } catch {
                print("Error decoding JSON:", error)
                completion([])
                return
            }
            
            completion(busRoutes)
        }
    
    
    func load<T: Decodable>(by path: String, completion: @escaping (T?) -> Void) {
        DispatchQueue.global(qos: .background).async {
             guard let fileURL = Bundle.main.url(forResource: path, withExtension: nil),
                   let data = try? Data(contentsOf: fileURL),
                   let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                 DispatchQueue.main.async {
                     completion(nil)
                 }
                 return
             }
             DispatchQueue.main.async {
                 completion(decodedData)
             }
         }
    }
}
