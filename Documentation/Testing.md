With Swish, we can define a mock implemenation of our API for use in testing. 

Suppose we have a request 

```swift
struct Comment: Codable {
  let id: Int
  let body: String
  let username: String

  enum CodingKeys: String, CodingKey {
    case id
    case body = "commentText"
    case username
  }
}

struct CommentRequest: Request {
  typealias ResponseObject = Comment


  func build() -> URLRequest {
    let url = URL(string: "https://raw.githubusercontent.com/thoughtbot/Swish/master/Documentation/example.json")!
    return URLRequest(url: url)
  }
}
```

We can define mock behavior for our API:

```swift
let client = MockClient()
  .when(CommentRequest.self, Comment(id: 0, body: "Not real!", username: "LarryDavid"))
  
// prints "Not real!"
client.performRequest(CommentRequest()) { response in 
  if case let .success(comment) = response {
    print(comment.body) 
  }
}
```

For more complicated requests, say if we had an id:

```swift
struct CommentRequestWithId: Request {
  typealias ResponseObject = Comment

  let id: Int
	
  func build() -> URLRequest {
    let url = URL(string: "https://raw.githubusercontent.com/thoughtbot/Swish/master/Documentation/example.json")!
    return URLRequest(url: url)
  }
}
```

We can define more complicated mock behaviors: 

```swift
let client = MockClient()
  .when(CommentRequestWithId(id: 0), Comment(id: 0, body: "Not real!", username: "LarryDavid"))
  .when(CommentRequestWithId(id: 1), Comment(id: 1, body: "What's the deal with not real comments!", username: "JerrySeinfeld"))
  .when { (req: CommentRequestWithId) -> SwishError? 
    if req.id > 1 && req.id < 10 {
	  return .some(.serverError(code: 404, date: .none))
    } else {
	  return .none
	}
  }
  .when(CommentRequestWithId.self, Comment(id: 999), body: "Bonus comment", username: "LarryDavid")
```

The order that mock functionality is defined matters: the mock client will return the response of the first matching request. 
