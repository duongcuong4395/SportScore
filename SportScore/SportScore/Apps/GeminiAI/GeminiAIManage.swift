//
//  GeminiAIManage.swift
//  SportScore
//
//  Created by pc on 11/09/2024.
//

import Foundation

import GoogleGenerativeAI
import CoreData
import SwiftUI

// MARK: - For manage
class GeminiAIManage {
    static var shared = GeminiAIManage()
    
    static var keyString: String = ""
    
    func getKey(from context: NSManagedObjectContext) -> (exists: Bool, model: GeminiAIModel) {
        var model = GeminiAIModel(itemKey: "key", valueItem: "")
        let condition = NSPredicate(format: "itemKey like %@", model.itemKey)
        let objs = context.getEntities(ofType: GeminiAI.self, with: condition)
        
        guard objs.models.count > 0 else {
            return (false, model)
        }
        model.valueItem = objs.models[0].valueItem ?? ""
        return (objs.models.count > 0, model)
    }
    
    
    func getModel(with model: GeminiAIModel) -> GenerativeModel {
        return GenerativeModel(
          name:   "gemini-1.5-flash-8b-exp-0827", 
          // "gemini-1.5-pro-latest",
          // "gemini-1.5-flash-latest",
          // gemini-1.5-flash-latest
          // gemini-1.5-flash-8b-exp-0827
          apiKey:  model.valueItem,
          generationConfig: GenerationConfig(
            temperature: 1,
            topP: 0.95,
            topK: 64,
            maxOutputTokens: 1048576, //8192,
            responseMIMEType: "text/plain"
          ),
          safetySettings: [
            SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
          ]
        )
    }
    
    func updateKey(with key: String, into context: NSManagedObjectContext, completed: @escaping (Bool) -> Void) {
        let model = GeminiAIModel(itemKey: "key", valueItem: "")
        let condition = NSPredicate(format: "itemKey like %@", model.itemKey)
        let objs = context.getEntities(ofType: GeminiAI.self, with: condition)
        let newModel = objs.models[0]
        newModel.valueItem = key
        try? context.save()
        completed(true)
    }
    
    func addKey(with key: String, into context: NSManagedObjectContext, completion: @escaping (Result<Bool, Error>) -> Void) {
        let modelFromCoreData = getKey(from: context)
        let model = GeminiAIModel(itemKey: "key", valueItem: key)
        print("gemini.addKey: " )
        model.add(into: context) { result in
            let condition = NSPredicate(format: "itemKey like %@", modelFromCoreData.model.itemKey)
            let objs = context.getEntities(ofType: GeminiAI.self, with: condition)
            print("gemini with key find: ", objs.models.count)
            print("gemini with key find data: ", objs.models[0].valueItem ?? "")
            completion(result)
        }
    }
    
    func mergeKey(with key: String, into context: NSManagedObjectContext, completion: @escaping (Result<Bool, Error>) -> Void) {
        let modelFromCoreData = getKey(from: context)
        if modelFromCoreData.exists {
            updateKey(with: key, into: context) { success in
                completion(.success(success))
                return
            }
            return
        }
        
        addKey(with: key, into: context) { success in
            //completed(success)
            completion(success)
        }
    }
    
    
}

// MARK: - For Event
protocol ChatGeminiEvent {}

extension ChatGeminiEvent {
    
    func checKeyExist(withKeyFrom context: NSManagedObjectContext, completed: @escaping (Bool) -> Void) {
        GeminiSend(prompt: "Print text: hello", and: true, withKeyFrom: context) { messResult, geminiStatus, keyString in
            DispatchQueueManager.share.runOnMain {
                switch geminiStatus {
                case .NotExistsKey, .ExistsKey, .SendReqestFail:
                    completed(false)
                case .Success:
                    completed(true)
                }
            }
        }
    }
    
    func GeminiSend(prompt: String, and hasStream: Bool, withKeyFrom context: NSManagedObjectContext, completed: @escaping (String, GeminiStatus, String) -> Void) {
        DispatchQueueManager.share.runInBackground {
            let modelKey = GeminiAIManage.shared.getKey(from: context)
            guard modelKey.exists else { completed("", .NotExistsKey, ""); return }
            
            let model = GeminiAIManage.shared.getModel(with: modelKey.model)
            let chat = model.startChat(history: [])
            
            Task {
              do {
                  if hasStream {
                      let responseStream =  chat.sendMessageStream(prompt)
                      for try await chunk in responseStream {
                          if let text = chunk.text {
                              completed(text, .Success, modelKey.model.valueItem)
                          }
                      }
                  } else {
                      let response = try await chat.sendMessage(prompt)
                      let _ = try await model.countTokens(prompt)
                      completed(response.text ?? "Empty", .Success, modelKey.model.valueItem)
                  }
              } catch {
                  completed("Data not found", .SendReqestFail, "")
              }
            }
        }
    }
    
    // MARK: - New
    func GeminiSend(prompt: String, and image: UIImage, withKeyFrom keyString: String, completed: @escaping (String) -> Void) {
        
        let modelKey = GeminiAIModel(itemKey: "key", valueItem: keyString)
        let model = GeminiAIManage.shared.getModel(with: modelKey)
        let _ = model.startChat(history: [])
        Task {
          do {
              let contentStream = model.generateContentStream(prompt, image)
              for try await chunk in contentStream {
                if let text = chunk.text {
                    completed(text)
                }
              }
          } catch {
              completed("Data not found")
          }
        }
    }
    
    func GeminiSend(prompt: String, and hasStream: Bool, withKeyFrom newKey: String, completed: @escaping (String, GeminiStatus) -> Void) {
        
        let modelKey = GeminiAIModel(itemKey: "key", valueItem: newKey)
        
        let model = GeminiAIManage.shared.getModel(with: modelKey)
        let chat = model.startChat(history: [])
        Task {
          do {
              if hasStream {
                  let responseStream = chat.sendMessageStream(prompt)
                  for try await chunk in responseStream {
                      if let text = chunk.text {
                          completed(text, .Success)
                      }
                  }
              } else {
                  let response = try await chat.sendMessage(prompt)
                  let _ = try await model.countTokens(prompt)
                  completed(response.text ?? "Empty", .Success)
              }
          } catch {
              
              print("=== Data not found", prompt, newKey)
              print("=== Data not found", GeminiStatus.SendReqestFail, error)
              completed("Data not found", .SendReqestFail)
          }
        }
    }
}

// MARK: - View add Key
struct GeminiAddKeyView: View, ChatGeminiEvent {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.managedObjectContext) var context
    @State var keyString: String = ""
    
    @State var resultMess: String = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "key")
                    .font(.caption2)
                Divider()
                // TextField
                SecureField(NSLocalizedString("Title_Enter_Key", comment: ""), text: $keyString.max(50))
                    Divider()
                Button(action: {
                    withAnimation {
                        if keyString.count > 0 {
                            resultMess = ""
                            checkKey()
                        }
                    }
                }, label: {
                    Text(NSLocalizedString("Check", comment: ""))
                        .font(.caption.bold())
                        .foregroundStyle(keyString.count > 0 ? .blue : .brown)
                })
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            
            if resultMess.count > 0 {
                Text(resultMess)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .shadow(radius: 3)
                    .padding(3)
                    .padding(.horizontal, 3)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
            }
            VStack(spacing: 5) {
                HStack {
                    Text(NSLocalizedString("NOTE", comment: "") + ":")
                        .font(.caption.bold())
                    Spacer()
                }
                HStack {
                    Text("- \(NSLocalizedString("getKeyByLink", comment: "")).")
                        .font(.caption)
                    Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                        Image(systemName: "link.circle.fill")
                            .font(.title3)
                    }
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("keyOnlyOnceInApp", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("keyNotShare", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("stableNetworkRequires", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
            }
        }
        //.foregroundStyleItemView(by: appVM.appMode)
    }
    
    func checkKey() {
        
        DispatchQueueManager.share.runOnMain {
            GeminiSend(prompt: "hãy cho tôi text: hello", and: true, withKeyFrom: keyString) { messResult, geminiStatus in
                switch geminiStatus {
                case .NotExistsKey:
                    print("Key is not exists")
                case .ExistsKey:
                    print("Key is exists")
                case .SendReqestFail:
                    print("Send Reqest Fail")
                    resultMess = "* \(NSLocalizedString("keyNotExists", comment: ""))."
                    keyString = ""
                case .Success:
                    print("Send Reqest Success ", messResult)
                    GeminiAIManage.shared.mergeKey(with: keyString, into: context) { result in
                        switch result {
                        case .success(let success):
                            guard success else { resultMess = "* \(NSLocalizedString("tryAgain", comment: ""))"; return }
                            resultMess = ""
                            appVM.showDialog = false
                            
                            GeminiAIManage.keyString = keyString
                        case .failure(let err):
                            return
                        }
                    }
                }
            }
        }
        
    }
}

extension Binding where Value == String {
    // MARK: - For max Length for text
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
