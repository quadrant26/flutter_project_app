# flutter_trip

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### 覆盖顶部状态栏
    
    ```dart
        MediaQuery.removePadding( // 移除屏幕顶部的边距
            removeTop: true,
            context: context,
            child: 
        )
    ```

### 滚动设置
    
    ```dart
    NotificationListener(
        onNotification: (scrollNotication){
            // 判断滚动距离
            if( scrollNotication is ScrollUpdateNotification && scrollNotication.depth == 0){
              // 滚动且是列表滚动的时候
              _onScroll(scrollNotication.metrics.pixels);
            }
        },
        child: 
    },
    ```

### 展开收起列表

    ```dart
    ExpansionTile(
        Key key,
        this.leading,
        @required this.title,
        this.backgroundColor,
        this.onExpansionChanged,
        this.children=<Widget>[]
        this.trailing,
        this.initiallyExpanded = false, // 默认状态下展开
    )
    ```

    ```dart
    RefreshIndicator(
        onRefresh: fn,
        child: 
    )
    ```
    
### 组件方法
    
    ```dart
        //充满整个屏幕* 屏幕宽度
        FractionallySizedBox(
            widthFactor： 1,
            child: 
        ) 
    ```
    
    ```dart 
        // 圆角
        PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          clipBehavior: Clip.antiAlias, // 裁切
        )
    ```