# fun_flutter

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 2019.11.15
1. 创建项目基础工程，上传代码。

# 2019.11.19
1. 搭建网络请求框架；
2. 初步完成首页的Model层构建；（ Model层：由实体类 + 网络请求仓库 + 网络请求框架 构成 ）
3. 初步完成基础ViewModel层构建；（基础ViewModel层：Mixin了ChangeNotify，实现了数据更新通知；添加了View的状态，方便界面展示；添加了刷新和加载功能，赋予其通用的列表功能。）
4. 需要结合Provider实现ViewModel的数据共享和获取唯一性质；

# 2019.11.20
1. 完成Provider层构建，完整实现ViewModel层；
2. 初步完成首页View层实现，完成首页Banner及列表数据加载；
3. 剩余点击回到顶部按钮功能异常问题；