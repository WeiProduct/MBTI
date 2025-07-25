# Debug Console Guide

## 🎯 Overview

The AIMBTI app now includes a comprehensive debug console system that helps developers track app behavior, debug issues, and monitor network requests in real-time.

## 🚀 Features

### 1. **Floating Debug Menu**
- A draggable floating button with a hammer icon
- Tap to expand and access debug tools
- Available options:
  - **Console**: Toggle debug console visibility
  - **Network**: Network debugging (placeholder)
  - **Logs**: Export logs to file
  - **Info**: Show app and device information
  - **Test**: Run debug tests

### 2. **Debug Console**
- **Minimized Mode**: Shows error and warning counts
- **Expanded Mode**: Full console with filtering and search
- **Auto-show on Error**: Console automatically appears when errors occur

### 3. **Log Levels**
- 🐜 **DEBUG**: Detailed debugging information
- ℹ️ **INFO**: General information
- ⚠️ **WARNING**: Warning messages
- ❌ **ERROR**: Error messages

### 4. **Log Categories**
- **General**: Default category
- **Chat**: Chat-related logs
- **Network**: API requests and responses
- **Test**: Test-related logs
- **Database**: Database operations
- **UI**: UI-related logs

## 📱 Usage

### In Your Code

```swift
// Debug log
DLog("This is a debug message")
DLog("User clicked button", category: "UI")

// Info log
ILog("API request started")
ILog("Received response", category: "Network")

// Warning log
WLog("Cache is getting full")
WLog("Slow network detected", category: "Network")

// Error log
ELog("Failed to save data")
ELog("API error: \(error)", category: "Network")
```

### Console Controls

1. **Search**: Filter logs by text
2. **Level Filter**: Show only specific log levels
3. **Clear**: Remove all logs
4. **Minimize/Maximize**: Toggle between compact and full view
5. **Export**: Save logs to a text file

## 🎨 Visual Features

- **Color-coded log levels** for quick identification
- **Expandable log entries** showing file, line, and function info
- **Real-time updates** as new logs arrive
- **Auto-scroll** to latest log entry
- **Dark mode support**

## 📝 Example Integration

The debug console is already integrated in:

1. **ChatService**: Logs API requests and responses
2. **TestViewModel**: Logs test actions
3. **Main App**: Accessible from any screen

## 🛠 Debug Menu Actions

### Export Logs
- Saves all logs to `/Documents/debug_logs_[timestamp].txt`
- Includes full details: timestamp, level, category, message, file location

### Show Info
Displays:
- App version and build number
- Device model and iOS version
- Current language setting
- API endpoints
- Proxy status

### Run Tests
Automatically generates test logs at different levels and categories to verify the console is working properly.

## ⚙️ Configuration

The debug console is only available in DEBUG builds. In release builds:
- All debug UI is hidden
- Log functions become no-ops
- No performance impact

## 🎯 Best Practices

1. **Use appropriate log levels**:
   - DEBUG: Detailed flow information
   - INFO: Important state changes
   - WARNING: Potential issues
   - ERROR: Actual failures

2. **Use categories** to group related logs

3. **Include context** in error messages

4. **Don't log sensitive information** (passwords, API keys, etc.)

## 🐛 Troubleshooting

### Console not appearing?
- Check if you're running a DEBUG build
- Try tapping the debug menu button
- Look for the floating hammer icon

### Too many logs?
- Use filters to focus on specific levels or categories
- Clear old logs regularly
- Search for specific keywords

### Performance issues?
- The console automatically limits to 500 most recent logs
- Clear logs if needed
- Minimize console when not in use

---

**Note**: The debug console is a development tool only and will not appear in App Store releases.