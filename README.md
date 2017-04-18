DLIntrospection
===============

Simple NSObject-category wrapper for &lt;objc/runtime.h> for methods/ivars/protocols/etc. listing. 
Automatically (often) resolves return types and argument types.

## Usage

Type the following commands in LLDB command promt:```~ po [NSObject classes]```
```
...
UIDateLabel,
UIDatePicker,
UIDatePickerContentView,
UIDevice,
UIDictationMeterView,
UIDictationPhrase
...
```
Lets list ```UIDevice``` **instance methods**: 
```
~ po [[UIDevice class] instanceMethods]
```
```
...
- (BOOL)isMediaPicker,
- (void)setIsMediaPicker:(BOOL)arg0 ,
- (id)systemVersion,
- (void)_unregisterForSystemSounds:(id)arg0 ,
- (void)_registerForSystemSounds:(id)arg0
...
```
Or **instance variables**:
```
~ po [[UIDevice class] instanceVariables]
```
```
int _numDeviceOrientationObservers,
float _batteryLevel
```

What **properties** (including private, of course) implements UIViewController?
```
~ po [[UIDevice class] properties]
```
```
@property (nonatomic, assign, readonly) BOOL _useSheetRotation,
@property (nonatomic, copy) @? afterAppearanceBlock,
...
@property (nonatomic, assign) {CGSize=ff} contentSizeForViewInPopover,
@property (nonatomic, assign, getter=isInAnimatedVCTransition) BOOL inAnimatedVCTransition,
@property (nonatomic, assign, readonly) BOOL inExplicitAppearanceTransition
```
What **protocols** implements NSData?
```
po [NSData protocols]
```
```
NSCopying,
NSMutableCopying,
NSSecureCoding <NSCoding>
```

Even cooler, let's see at <NSObject> protocol information (lists **@required**, **@optional** methods and **@properties**):
```
NSLog(@"%@", [NSObject descriptionForProtocol:@protocol(NSObject)]);
```
```
    "@required" =     (
        "- (void)debugDescription",
        "- (void)zone",
        "- (void)performSelector:withObject:withObject:",
        "- (void)description",
        ...
        "- (void)performSelector:",
        "- (void)performSelector:withObject:",
        "- (void)self",
        "- (void)conformsToProtocol:",
        "- (void)class"
    );
```

## Bindings:

There also exists an `OCaml` binding so you can play use the code
interactively with the `utop` repl, see
[here](https://github.com/fxfactorial/ocaml-objc) under the
`Introspect` module.

## Known issues:

1. Not all argument types are handled yet (structs, bitmasks);
2. return and arguments types of protocol methods are not parsed yet.

## LICENSE

[Beerware](https://en.wikipedia.org/wiki/Beerware)
