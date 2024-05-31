import Foundation

class ChatBotAPI {
    
    func sendOpenAIRequest(messages: [OpenAIChatBody.ChatMessage], completion: @escaping (String?) -> Void) {        
        let apiKey = "sk-weskey-Gg9RKU7KlvOuRnmNWRNbT3BlbkFJfS7k2VutOIPybX4755Gr"
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "max_tokens": 2000
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON String: \(jsonString)")
                }
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let error = json["error"] as? [String: Any],
                       let errorMessage = error["message"] as? String {
                        print("Error from API: \(errorMessage)")
                        completion(nil)
                        return
                    }
                    
                    if let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    } else {
                        print("Invalid JSON format")
                        completion(nil)
                    }
                } else {
                    print("Invalid JSON format - root object is not a dictionary")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
