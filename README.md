# FSPopoverBubble

FSPopoverBubble is a simple UI element for iOS that can display text and optional buttons. It's great for custom alerts and on-boarding, and supports customization of most of it's visual properties. Animation is handled with easing functions to give the appearance and disappearance of the popover a smooth, unique look.

[]()

## Installation
Simply download this repository and copy _FSPopoverBubble.swift_ into your project.

## Usage
For a basic popover with just text and no arrow:
```
let popover = FSPopoverBubble(withText: "Basic popover. Here is some text!")
popover.present(animated: true)
```

If `present:` is called with no view controller, it attempts to present the popover in the currently visible view controller. To present a popover in a specific view controller, call `present(inViewController:animated:)` or `present(inViewController:at:animated:)`.

For a popover with text and an arrow:
```
let popover = FSPopoverBubble(withText: "Look here!", arrowDirection: .down)
popover.present(at: CGPoint(x: 40.0, y: view.frame.height - 60.0), animated: true)
```

When presenting a popover with an arrow, specifying a point will attempt to place the popover with the tip of the arrow at the given location. Otherwise, if the popover does not have an arrow, presenting it will attempt to place the popover with its center at the given point. Popovers will  prevent themselves from clipping in the view they are presented in.

For a popover with default buttons:
```
let popover = FSPopoverBubble(withText: "Here are two buttons:", buttonTitles: ["Button one", "Button two"], arrowDirection: .up)
popover.textFont = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
popover.buttonFont = UIFont(name: "HelveticaNeue", size: 20.0)
popover.buttonHandler = { po, index in
    print("Pressed button \(index)")
    po.dismiss(animated: true)
}
popover.dismissesOnTap = false
popover.present(at: CGPoint(x: view.center.x, y: 20.0), animated: true)
```

The above example also illustrates some custom properties like `textFont`, `buttonFont`, and `dismissesOnTap`.

For a popover with custom buttons:
```
let button0: UIButton = ...
let button1: UIButton = ...
let popover = FSPopoverBubble(withText: "Showing some custom buttons.", buttons: [button0, button1])
...
```

## Advanced
Customizable properties include:
- `color` (the color of the popover and arrow, if any)
- `cornerRadius`
- `textFont` (the font used for the popover's text)
- `textColor` (the color used for the popover's text)
- `buttonFont` (the font used for the title labels of the popover's default buttons)
- `buttonColor` (the color used for the popover's default buttons' background color)
- `dismissesOnTap` (controls whether the popover should automatically dismiss itself if tapped)

## License
FSPopoverBubble is released under the MIT license. See [LICENSE](https://github.com/cfloisand/FSPopoverBubble/blob/master/LICENSE.txt) for more details.

