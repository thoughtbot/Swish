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

struct Comment: Decodable {
  let id: Int
  let text: String
  let username: String

  static func decode(json: JSON) -> Decoded<Comment> {
    return curry(Comment.init)
      <^> j <| "id"
      <*> j <| "commentText"
      <*> j <| "username"
  }
}
```

We can model the request by defining a struct that implement's Swish's `Request` protocol:

```swift
struct CommentRequest: Request {
  typealias ResponseObject = Comment
  let id: Int

  func build() -> NSURLRequest {
    let url = NSURL(string: "https://www.example.com/comments/\(id)")!
    return NSURLRequest(URL: url)
  }
}
```

We can then use the Swish's default `APIClient` to make the request:

```swift
let request = CommentRequest(id: 1)

let dataTask = APIClient().performRequest(request) { (response: Result<Comment, SwishError>) in
  if let value = response.value {
    print("Here's the comment: \(value)")
  } else if let error = response.error {
    print("Oh no, an error: \(error)")
  }
}
```

And that's it!
