import Foundation


struct Message {
    var text: String
    var isUser: Bool
    var isLoading: Bool = false
}


struct OpenAIChatBody: Encodable {
    let model: String
    var messages: [ChatMessage]
    
    struct ChatMessage: Encodable {
        let role: String
        let content: String
    }
}

struct OpenAIResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [OpenAIResponseChoice]
    
    struct Usage: Decodable {
        let total_tokens: Int
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_completions: Int?
    }
}

struct OpenAIResponseChoice: Decodable {
    let message: ResponseMessage
    
    struct ResponseMessage: Decodable {
        let role: String
        let content: String
    }
}
