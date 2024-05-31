
import Foundation

struct Post {
    let title: String
    let content: String
    let category: String
}

struct PostCategory {
    let category: String
    let posts: [Post]
}
