# Flutter项目编码规范与错误预防规则

## 🎯 核心原则

基于 Prisma Note 项目开发过程中遇到的真实问题，制定以下编码规范以避免重复错误。

---

## ⚡ 异步操作安全规则

### 🚨 1. BuildContext 异步安全规则

**问题背景**: 开发中遇到 `Looking up a deactivated widget's ancestor is unsafe` 和 `setState() called after dispose()` 错误

**核心规则**:
```dart
// ✅ 必用模式
Future<void> asyncFunction() async {
  if (!mounted) return;  // 异步操作前必须检查
  
  // 异步操作
  final result = await someAsyncOperation();
  
  // 更新UI前再次检查
  if (!mounted) return;
  
  setState(() {
    // UI更新
  });
}

// ❌ 禁用模式
void badAsyncFunction() async {
  setState(() {
    // 如果widget已dispose，这里会崩溃
  });
}
```

**检查清单**:
- [ ] 所有异步函数都要检查 `mounted` 状态
- [ ] 在 `.then()` 回调中检查 `mounted`
- [ ] 在 `await` 后的代码块中检查 `mounted`
- [ ] 在 FutureBuilder 的 builder 中检查 `context`

### 🚨 2. 异步操作完整模式

**推荐模板**:
```dart
Future<void> handleAsyncOperation() async {
  try {
    // 1. 检查状态
    if (!mounted) return;
    
    // 2. 显示loading状态（如果需要）
    setState(() => _isLoading = true);
    
    // 3. 执行异步操作
    final result = await _service.operation();
    
    // 4. 安全检查
    if (!mounted) return;
    
    // 5. 更新状态
    setState(() {
      _data = result;
      _isLoading = false;
    });
    
  } catch (error) {
    // 6. 错误处理
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _error = error.toString();
    });
    
    // 7. 显示错误信息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_error!)),
    );
  }
}
```

---

## 📊 代码质量控制规则

### 🔍 1. 开发阶段检查

**每次代码提交前必须**:
- [ ] 运行 `flutter analyze` 检查代码质量
- [ ] 运行 `flutter format .` 格式化代码
- [ ] 检查是否有未使用的导入
- [ ] 检查是否有未使用的变量

**常用命令**:
```bash
# 代码质量检查
flutter analyze

# 代码格式化
flutter format .

# 依赖检查
flutter pub deps

# 更新依赖
flutter pub upgrade --major-versions
```

### 🧹 2. 代码清理规则

**自动清理策略**:
```dart
// ❌ 清理前
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';  // 未使用
import '../services/old_service.dart';  // 未使用

class Widget {
  final String _unusedVariable = "test";  // 未使用
  void method() {
    int unused = 42;  // 未使用
  }
}

// ✅ 清理后
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Widget {
  void method() {
    // 代码已清理
  }
}
```

**IDE设置建议**:
- 启用 "Show unused imports" 警告
- 启用 "Remove unused parameters" 自动清理
- 定期运行 "Code > Analyze Code" 

---

## 🔧 Flutter API最佳实践

### 🎨 1. 颜色API更新

**问题**: `withOpacity` 在Flutter 3.x中已废弃

**修复规则**:
```dart
// ❌ 旧API（已废弃）
Color withOpacityColor = Colors.blue.withOpacity(0.5);

// ✅ 新API
Color withValuesColor = Colors.blue.withValues(alpha: 0.5);
```

**检查清单**:
- [ ] 搜索项目中所有 `withOpacity` 调用
- [ ] 替换为 `withValues(alpha: value)`
- [ ] 验证颜色效果保持一致

### 📱 2. Material Design 3

**推荐用法**:
```dart
// ✅ 推荐的Material 3样式
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
)

// ✅ 统一的容器样式
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey[300]!),
  ),
)

// ✅ 统一的字体样式
Text(
  'Title',
  style: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
)
```

---

## 🏗️ 项目特定规则

### 📂 1. 目录结构规范

**强制目录结构**:
```
lib/
├── main.dart              # 应用入口
├── models/                # 数据模型
│   └── timeline_item.dart
├── providers/             # 状态管理
│   ├── timeline_provider.dart
│   └── audio_recorder_service.dart
├── services/              # 业务服务
│   └── audio_recorder_service.dart
├── pages/                 # 页面组件
│   ├── timeline_page.dart
│   ├── events_page.dart
│   └── library_page.dart
└── widgets/               # 可复用组件
    ├── floating_action_widget.dart
    └── sound_wave_visualizer.dart
```

### 🔄 2. Provider使用规则

**正确模式**:
```dart
// ✅ main.dart 中设置Provider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => TimelineProvider()),
    ChangeNotifierProvider(create: (_) => AudioRecorderService()),
  ],
  child: const PrismaNoteApp(),
)

// ✅ 消费Provider（精确控制）
Consumer<TimelineProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.timelineItems.length,
      itemBuilder: (context, index) {
        return TimelineItemWidget(item: provider.timelineItems[index]);
      },
    );
  },
)

// ✅ 获取Provider（只读）
final provider = Provider.of<TimelineProvider>(context, listen: false);
```

**错误模式**:
```dart
// ❌ 全局监听（不必要的重建）
Consumer<TimelineProvider>(
  builder: (context, provider, child) {
    // 整个widget树重建
    return MaterialApp(...);
  },
)

// ❌ 忘记listen: false
final provider = Provider.of<TimelineProvider>(context); // 默认listen: true
```

### 🎤 3. 音频服务规范

**单例模式规范**:
```dart
class AudioRecorderService extends ChangeNotifier {
  static final AudioRecorderService _instance = AudioRecorderService._internal();
  factory AudioRecorderService() => _instance;
  AudioRecorderService._internal();
  
  // ✅ 流管理
  final StreamController<double> _amplitudeController = 
      StreamController<double>.broadcast();
  
  Stream<double> get amplitudeStream => _amplitudeController.stream;
  
  // ✅ 权限管理
  Future<bool> requestMicrophonePermission() async {
    final permission = await Permission.microphone.request();
    final hasPermission = permission == PermissionStatus.granted;
    
    if (!hasPermission) {
      debugPrint('Microphone permission denied');
    }
    
    notifyListeners();
    return hasPermission;
  }
  
  // ✅ 资源释放
  @override
  void dispose() {
    _amplitudeController.close();
    super.dispose();
  }
}
```

---

## 🚨 错误预防检查清单

### 📋 开发前检查
- [ ] 确认Flutter SDK版本和依赖兼容性
- [ ] 检查当前分支是否是最新的
- [ ] 运行 `flutter analyze` 确保代码无错误
- [ ] 检查是否有未提交的更改

### ⚡ 异步操作检查
- [ ] 所有异步函数都有 `mounted` 检查
- [ ] `.then()` 回调中有 `mounted` 检查
- [ ] `await` 操作后的代码块有 `mounted` 检查
- [ ] 异常处理包含mounted检查
- [ ] StreamSubscription在dispose中正确释放

### 🎨 UI组件检查
- [ ] 没有使用废弃的API（如 `withOpacity`）
- [ ] 所有Container有合适的padding/margin
- [ ] Text样式统一使用Google Fonts
- [ ] 颜色主题一致性
- [ ] Material Design 3 规范遵循

### 📊 数据流检查
- [ ] Provider正确设置在main.dart中
- [ ] Consumer使用精确的重建范围
- [ ] 数据更新调用notifyListeners()
- [ ] 状态变更触发正确的UI更新
- [ ] 错误状态有适当的用户反馈

### 🔧 代码质量检查
- [ ] 没有未使用的导入语句
- [ ] 没有未使用的变量或方法
- [ ] 代码格式符合Flutter标准
- [ ] 注释清晰且最新
- [ ] 方法/类名称清晰描述功能

---

## 🔍 调试工具推荐

### 常用命令
```bash
# 完整代码质量检查
flutter analyze && flutter format . && flutter test

# 依赖分析
flutter pub deps

# 设备检查
flutter devices

# 启动热重载
flutter run -d chrome

# 构建发布版本
flutter build apk --release
```

### 调试技巧
```dart
// ✅ 开发时添加调试信息
void debugLog(String message) {
  if (kDebugMode) {
    print('[${DateTime.now()}] $message');
  }
}

// ✅ 异步操作错误捕获
try {
  final result = await operation();
  debugLog('操作成功: $result');
} catch (error, stackTrace) {
  debugLog('操作失败: $error');
  debugLog('堆栈跟踪: $stackTrace');
  rethrow;
}
```

---

## 📝 总结

这些规则基于 Prisma Note 项目开发过程中遇到的真实问题制定，重点解决：

1. **异步BuildContext安全** - 防止应用崩溃
2. **代码质量控制** - 保持代码整洁
3. **Flutter API最佳实践** - 跟随框架发展
4. **项目特定规范** - 维护架构一致性

**遵循这些规则将显著减少开发错误，提高代码质量和维护性。**

---

*创建日期: 2024-12-14*  
*基于: Prisma Note 项目开发经验*  
*版本: v1.0*