# Basic Usage #

Let's say you have an endpoint, `GET https://www.example.com/comments/1`, that returns the following JSON:

```json
{
  "id": 1,
  "commentText": "Pretty good. Pret-ty pre-ty pre-ty good.",
  "username": "LarryDavid"
}
```

We'll model this with the following struct, and implement Argo's `Decodable` protocol to tell it how to deal with JSON:

```swift
import Argo
import Curry

struct Comment {
  let id: Int
  let text: String
  let username: String
}

extension Comment: Decodable {
  static func decode(_ json: JSON) -> Decoded<Comment> {
    return curry(Comment.init)
      <^> j <| "id"
      <*> j <| "commentText"
      <*> j <| "username"
  }
}
```

We can model the request by defining a struct that implement's Swish's `Request` protocol:

```swift
import Swish

struct CommentRequest: Request {
  typealias ResponseObject = Comment

  let id: Int

  func build() -> URLRequest {
    let url = URL(string: "https://www.example.com/comments/\(id)")!
    return URLRequest(URL: url)
  }
}
```

We can then use the Swish's default `APIClient` to make the request:

```swift
let getComment = CommentRequest(id: 1)

APIClient().perform(getComment) { (response: Result<Comment, SwishError>) in
  switch response {
  case let .success(comment):
    print("Here's the comment: \(comment)")
  case let .failure(error):
    print("Oh no, an error: \(error)")
  }
}
```

And that's it!
