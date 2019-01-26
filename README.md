<p align="center"><img src="https://raw.githubusercontent.com/thoughtbot/Swish/gh-pages/swish-logo-v5.jpg" width="375"></p>

# Swish [![CircleCI](https://circleci.com/gh/thoughtbot/Swish.svg?style=svg)](https://circleci.com/gh/thoughtbot/Swish) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat-square)](https://github.com/Carthage/Carthage) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Swish.svg)](https://img.shields.io/cocoapods/v/Swish.svg)  


Nothing but net(working).

Swish is a networking library that is particularly meant for requesting and
decoding JSON via `Decodable`. It is protocol based, and so aims to be easy
to test and customize.

## Version Compatibility

Here is the current Swift compatibility breakdown:

| Swift Version | Swish Version |
| ------------- | ------------  |
|           4.X | >= 3.0.0      |
|           3.X | > 2.0, < 3.0  |
|           2.X | 1.X           |

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

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'Swish'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

### Git Submodules

I guess you could do it this way if that's your thing.

Add this repo as a submodule, and add the Swish project file along with the
dependency project files to your workspace. You can then link against
`Swish.framework` along with the dependency frameworks for your application
target.

## Usage

### Basic Playground

You can see an example of Swish in action via the included `SwishExamples.playground`.

To use that, clone this repository and run `carthage bootstrap --platform iOS`.
When that finishes, open the `Swish.xcworkspace` and click the `SwishExamples`
playground on the left.

### Documentation

- [Basic Usage](Documentation/Basics.md)

## License

Swish is Copyright (c) 2016 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

Swish is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/ios?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
