# Prisma Note

一款基于 Flutter 开发的个人效率管理应用，集成了时间轴记录、项目管理、语音备忘录和联系人管理等功能。

## ✨ 功能特性

### 📅 时间轴 (Timeline)
- 按日期查看和管理时间轴项目
- 支持多种类型：笔记、事件、任务、语音备忘录、会议、提醒
- 简洁视图和详细视图切换
- 日期选择器和搜索功能
- 音频波形可视化展示

### 📊 事件与项目 (Events & Projects)
- 项目状态管理：进行中、待办、搁置、已完成、生活
- 项目进度追踪
- 优先级设置
- 标签分类系统
- 截止日期管理

### 📚 资源库 (Library)
- **任务管理**：年视图、月视图、日视图规划
- **联系人管理**：工作、客户、个人、服务、家庭分类
- **备忘录**：灵感收集、书签管理、收藏夹
- **健康管理**：活动图表、运动追踪、健康指标

### 🎤 语音录制
- 实时音频录制功能
- 音频波形可视化
- 录音文件本地存储
- AAC 高质量音频编码

## 🏗️ 项目架构

```
lib/
├── main.dart                    # 应用入口
├── constants/                   # 常量定义
│   ├── app_colors.dart         # 应用颜色
│   └── app_text_styles.dart    # 文本样式
├── models/                      # 数据模型
│   ├── timeline_item.dart      # 时间轴项目
│   ├── event_project.dart      # 事件项目
│   └── contact.dart            # 联系人
├── pages/                       # 页面组件
│   ├── timeline_page.dart      # 时间轴页面
│   ├── events_page.dart        # 事件项目页面
│   └── library_page.dart       # 资源库页面
├── providers/                   # 状态管理
│   └── timeline_provider.dart  # 时间轴状态
├── routing/                     # 路由配置
│   └── app_router.dart         # GoRouter 配置
├── services/                    # 业务服务
│   └── audio_recorder_service.dart  # 音频录制服务
├── theme/                       # 主题配置
│   └── app_theme.dart          # 应用主题
├── utils/                       # 工具类
│   └── date_utils.dart         # 日期工具
└── widgets/                     # 可复用组件
    ├── cards/                  # 卡片组件
    ├── sheets/                 # 底部弹窗
    ├── floating_action_widget.dart
    ├── main_scaffold.dart
    ├── project_card.dart
    ├── project_grid.dart
    ├── recording_overlay.dart
    └── sound_wave_visualizer.dart
```

## 🚀 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart ^3.9.2
- **状态管理**: Provider ^6.1.2
- **路由**: go_router ^17.0.1
- **UI**: Material Design 3 + Google Fonts
- **音频**: record ^6.1.2
- **权限**: permission_handler ^12.0.1
- **路径**: path_provider ^2.1.2
- **其他**: uuid, intl

## 📱 支持平台

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 🛠️ 开发环境

### 环境要求
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- Android Studio / Xcode (用于移动平台)

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd prisma_note
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
# 开发模式
flutter run

# 指定平台
flutter run -d android
flutter run -d ios
flutter run -d macos
flutter run -d windows
flutter run -d chrome
```

## 📋 代码规范

### 异步操作安全
```dart
Future<void> asyncFunction() async {
  if (!mounted) return;  // 异步操作前检查
  
  final result = await someAsyncOperation();
  
  if (!mounted) return;  // 更新UI前再次检查
  
  setState(() {
    // UI更新
  });
}
```

### 代码质量检查
```bash
# 代码分析
flutter analyze

# 代码格式化
flutter format .

# 运行测试
flutter test
```

## 🔧 主要功能模块

### 时间轴项目类型
| 类型 | 说明 |
|------|------|
| note | 普通笔记 |
| event | 事件记录 |
| task | 任务项 |
| voiceMemo | 语音备忘录 |
| meeting | 会议记录 |
| reminder | 提醒事项 |

### 项目状态
| 状态 | 说明 |
|------|------|
| backlog | 待办 |
| inProgress | 进行中 |
| completed | 已完成 |
| onHold | 搁置 |
| cancelled | 已取消 |
| life | 生活 |

### 联系人类型
| 类型 | 说明 |
|------|------|
| work | 工作 |
| client | 客户 |
| personal | 个人 |
| service | 服务 |
| family | 家庭 |

## 🎨 设计系统

- **主色调**: 基于 Material Design 3 的颜色系统
- **字体**: Inter (Google Fonts)
- **圆角**: 统一的 12px 圆角设计
- **间距**: 遵循 8px 网格系统

## 📝 待办事项

- [ ] 数据持久化存储 (SQLite/Hive)
- [ ] 云同步功能
- [ ] 语音转文字功能
- [ ] AI 智能摘要生成
- [ ] 深色模式支持
- [ ] 多语言支持
- [ ] 导出功能 (PDF, Markdown)

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 👨‍💻 开发者

- **Prisma Note Team**

---

<p align="center">Made with ❤️ using Flutter</p>
