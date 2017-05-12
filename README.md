# Dimmer
An easy extension library that supports dimming functionality on UIView and UIViewController.

# Example
```
To dim view,
view.dim() / view.undim()

To dim a view with filling direction and size,
view.dim(.fromTop, ratio: 0.5)

To show loading view,
view.showLoading() / view.hideLoading()

To show loading view with indicator style,
view.showLoading(style: .whiteLarge) / view.hideLoading()
```

# Installation

Dimmer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Dimmer"
```
