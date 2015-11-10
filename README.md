# FKSlideshowView

---

## Description

UIImageをNSArrayで渡すと自動的にスライドショーを行います。  
現在はクロスフェードにのみ対応しています。

---

## Usage

```Objective-C
NSArray *images = @[...]; // NSArray<UIImage,,,>
FKSlideshowView *slideshowView = [[FKSlideshowView alloc] initWithImages:images];
slideshowView.duration = 8.0f;
slideshowView.fade     = 0.3f;
self.view.addSubview(slideshowView);
[slideshowView play];
```

---

## Public Methods

```Objective-C
- (instancetype)initWithImages:(NSArray *)images;
- (void)play;
- (void)pause;
- (BOOL)playing;
```
