<img src="https://raw.githubusercontent.com/thoughtbot/Swish/gh-pages/swish-logo-v4.jpg" width="600">

# Swish [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat-square)](https://github.com/Carthage/Carthage)

Nothing but net(working).

Swish is a networking library that is particularly meant for requesting and
decoding JSON via [Argo](http://github.com/thoughtbot/Argo). It is protocol
based, and so aims to be easy to test and customize.

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "thoughtbot/Swish"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

## Basic Usage
```swift
import Swish

func baseRequest(url url: String, method: RequestMethod) -> NSURLRequest {
  let url = NSURL(string: url)!
  let request = NSMutableURLRequest(URL: url)

  request.HTTPMethod = method.rawValue
  return request
}

struct CommentRequest: Request {
  typealias ResponseObject = Comment

  let id: Int

  func build() -> NSURLRequest {
    let endpoint = "http://example.com/api/comment/\(id)"

    return baseRequest(endpoint: endpoint, method: .GET)
  }
}

struct Comment: Decodable {
  let id: Int
  let text: String
  let username: String

  static func decode(j: JSON) -> Decoded<Comment> {
    return curry(Comment.init)
      <^> j <| "id"
      <*> j <| "commentText"
      <*> j <| "username"
  }
}

let request = CommentRequest(id: 1)
APIClient().performRequest(request) { (response: Result<Comment, NSError>) in
  // ...
}
```

We declare a struct that conforms to the `Request` protocol, which forces us to:

* Declare a `ResponseObject` that should be `Decodable`, which allows Swish to use
  Argo to decode the HTTP response into the appropriate model.
* Declare a `build` function, which defines the request to perform.
  HTTP method to use.

Then, we can use `APIClient#performRequest` to actually perform the request, and
its callback will have an argument of type `Result<ResponseObject, NSError>`.

## Advanced Usage
One can additionally override the default implementation of both
`APIClient#performRequest` and `Request#parse` to provide more custom behavior.

The default `APIClient#performRequest` does the following:

* Check that the HTTP Status Code is between `200...299`, else return an
  `NSError`.
* Parse the response's data into `Argo.JSON`
* Pass this `JSON` to the `Request#parse` function.

The default `Request#parse` just passes the `JSON` it is called with to the
`ResponseObject.decode` function.

As an example of a custom `parse` function, let's assume that in the example
above, the API returns an array of objects, and we want to parse only the first
one into a `Comment`, or otherwise fail:

```swift
struct CommentRequest: Request {
  typealias ResponseObject = Comment

  let id: Int

  func build() -> NSURLRequest {
    let endpoint = "http://example.com/api/comment/\(id)"

    return baseRequest(endpoint: endpoint, method: .GET)
  }

  func parse(j: JSON) -> Result<Comment, NSError> {
    let comments = [Comment].decode(j)
    let comment = comments.flatmap { comments -> Decoded<Comment> in
      guard let comment = comments.first else {
        return .Failure(.Custom("No comments returned!"))
      }

      return .Success(comment)
    }

    return .fromDecoded(comment)
  }
}
```

Here, our parse function will first decode into an array of `Comment` objects,
and then return the first if found, otherwise an error. The `fromDecoded`
function converts from Argo's `Decoded<T>` type to `Result<T, NSError>`.

## License

Swish is Copyright (c) 2015 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![thoughtbot](https://thoughtbot.com/logo.png)

Swish is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/ios?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
