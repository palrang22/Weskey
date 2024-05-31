
import UIKit

class ChattingViewController: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var initialMessage: String?
    var messages: [Message] = []
    var chatMessages: [OpenAIChatBody.ChatMessage] = []
    let chatService = ChatBotAPI()
    let placeholderText = "자유롭게 물어보세요!"
       
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        configTextView()
        
        if let initialMessage = initialMessage {
            addMessage(initialMessage, fromUser: true)
            
            if initialMessage == "맞춤 위스키 추천 시작!" {
                let response = """
                       안녕하세요! 위스키를 추천해드리는 위스키(we's key)입니다. 취향에 맞는 완벽한 위스키를 찾기 위해 몇 가지 질문을 드릴게요. 천천히 답해주시면 됩니다!
                       1. 어떤 맛을 좋아하시나요? (예: 달콤한 맛, 매콤한 맛, 과일 맛, 스모키한 맛 등)
                       2. 어떤 향을 선호하시나요? (예: 바닐라 향, 과일 향, 나무 향, 시트러스 향 등)
                       예산은 어느 정도 생각하고 계신가요? (예: 3만 원 이하, 3만 원에서 5만 원 사이, 5만 원 이상)
                       각 질문에 답해주시면 추천 위스키를 찾아드릴게요! 모르시는 부분은 건너뛰셔도 괜찮아요.
                       """
                addMessage(response, fromUser: false)
                chatMessages.append(OpenAIChatBody.ChatMessage(role: "system", content: response))
            } else {
                let userMessage = OpenAIChatBody.ChatMessage(role: "user", content: initialMessage)
                chatMessages.append(userMessage)
                chatService.sendOpenAIRequest(messages: chatMessages) { response in
                    DispatchQueue.main.async {
                        if let response = response {
                            self.addMessage(response, fromUser: false)
                            self.chatMessages.append(OpenAIChatBody.ChatMessage(role: "assistant", content: response))
                        } else {
                            self.addMessage("OpenAI 응답을 받지 못했습니다.", fromUser: false)
                        }
                    }
                }
            }
        }
    }
       
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.scrollToBottom()
        }
    }
       
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = inputTextView.text, !text.isEmpty else { return }
                addMessage(text, fromUser: true)
                inputTextView.text = ""
                
                let userMessage = OpenAIChatBody.ChatMessage(role: "user", content: text)
                chatMessages.append(userMessage)
                
        chatService.sendOpenAIRequest(messages: chatMessages) { response in
            DispatchQueue.main.async {
                if let response = response {
                    self.addMessage(response, fromUser: false)
                    self.chatMessages.append(OpenAIChatBody.ChatMessage(role: "assistant", content: response))
                }
            }
        }
    }
    
    func configTextView() {
        inputTextView.delegate = self
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.text = placeholderText
        inputTextView.textColor = UIColor.darkGray
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -200
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.darkGray
        }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
        
    func addMessage(_ text: String, fromUser isUser: Bool) {
        let formattedText = formatTextWithNewlines(text)
        let message = Message(text: formattedText, isUser: isUser)
        messages.append(message)
        
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.scrollToBottom()
        }
    }

    func formatTextWithNewlines(_ text: String) -> String {
        return text.replacingOccurrences(of: ". ", with: ".\n")
    }
        
    func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
        
    func clearMessages() {
        messages.removeAll()
        chatMessages.removeAll()
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            print("Error: collectionView is nil")
        }
    }
        
        // MARK: - UICollectionViewDataSource
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: message)
        return cell
    }
        
        // MARK: - UICollectionViewDelegateFlowLayout
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.item]
        let width = collectionView.frame.width
        let estimatedHeight = estimateFrameForText(message.text).height + 20
        return CGSize(width: width, height: estimatedHeight)
    }
        
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: collectionView.frame.width - 30, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
