Let's say we have an endpoint, `GET https://raw.githubusercontent.com/thoughtbot/Swish/master/Documentation/example.json`
that returns the following JSON:

```json
{
  "id": 4,
  "commentText": "Pretty good. Pret-ty pre-ty pre-ty good.",
  "username": "LarryDavid"
}
```

We will model the data with the following struct
and conform to the `Codable` protocol so we can
turn from JSON into a Swift object.

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
```

We can model the request by defining a struct that
implements Swish's `Request` protocol

```swift
struct CommentRequest: Request {
  typealias ResponseObject = Comment


  func build() -> URLRequest {
    let url = URL(string: "https://raw.githubusercontent.com/thoughtbot/Swish/master/Documentation/example.json")!
    return URLRequest(url: url)
  }
}
```

We can then use the Swish's default `APIClient` to make the request:

```swift
APIClient().perform(CommentRequest()) { (response: Result<Comment, SwishError>) in
  switch response {
  case let .success(comment):
    print("Here's the comment: \(comment)")
  case let .failure(error):
    print("Oh no, an error: \(error)")
  }
}
```

And that's it!
