#!/usr/bin/env python3
"""
生成 iOS App 所需的所有图标尺寸
"""

import os
from PIL import Image
import sys

# 定义所需的图标尺寸
icon_sizes = [
    # iPhone Notification
    (40, "Icon-20@2x"),
    (60, "Icon-20@3x"),
    
    # iPhone Settings
    (58, "Icon-29@2x"),
    (87, "Icon-29@3x"),
    
    # iPhone Spotlight
    (80, "Icon-40@2x"),
    (120, "Icon-40@3x"),
    
    # iPhone App
    (120, "Icon-60@2x"),
    (180, "Icon-60@3x"),
    
    # iPad Notifications
    (20, "Icon-20"),
    (40, "Icon-20@2x"),
    
    # iPad Settings
    (29, "Icon-29"),
    (58, "Icon-29@2x"),
    
    # iPad Spotlight
    (40, "Icon-40"),
    (80, "Icon-40@2x"),
    
    # iPad App
    (76, "Icon-76"),
    (152, "Icon-76@2x"),
    
    # iPad Pro App
    (167, "Icon-83.5@2x"),
    
    # App Store
    (1024, "Icon-1024"),
]

def generate_icons(source_path, output_dir):
    """生成所有尺寸的图标"""
    
    # 创建输出目录
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # 打开原始图片
    try:
        original_img = Image.open(source_path)
        print(f"✅ 成功加载原始图标: {source_path}")
        print(f"   原始尺寸: {original_img.size}")
    except Exception as e:
        print(f"❌ 无法加载图片: {e}")
        return
    
    # 确保图片是正方形
    if original_img.width != original_img.height:
        print("⚠️  警告: 原始图片不是正方形，将进行裁剪")
        size = min(original_img.width, original_img.height)
        original_img = original_img.crop((0, 0, size, size))
    
    # 转换为RGBA模式
    if original_img.mode != 'RGBA':
        original_img = original_img.convert('RGBA')
    
    # 生成各种尺寸
    print("\n开始生成图标...")
    for size, filename in icon_sizes:
        try:
            # 调整尺寸
            resized_img = original_img.resize((size, size), Image.Resampling.LANCZOS)
            
            # 保存图片
            output_path = os.path.join(output_dir, f"{filename}.png")
            resized_img.save(output_path, 'PNG', optimize=True)
            
            print(f"✅ {filename}.png ({size}x{size})")
        except Exception as e:
            print(f"❌ 生成 {filename}.png 失败: {e}")
    
    print("\n✨ 图标生成完成！")
    print(f"📁 输出目录: {output_dir}")
    
    # 创建 Contents.json 文件
    create_contents_json(output_dir)

def create_contents_json(output_dir):
    """创建 Xcode 所需的 Contents.json 文件"""
    
    contents = {
        "images": [
            # iPhone Notification
            {"size": "20x20", "idiom": "iphone", "filename": "Icon-20@2x.png", "scale": "2x"},
            {"size": "20x20", "idiom": "iphone", "filename": "Icon-20@3x.png", "scale": "3x"},
            
            # iPhone Settings
            {"size": "29x29", "idiom": "iphone", "filename": "Icon-29@2x.png", "scale": "2x"},
            {"size": "29x29", "idiom": "iphone", "filename": "Icon-29@3x.png", "scale": "3x"},
            
            # iPhone Spotlight
            {"size": "40x40", "idiom": "iphone", "filename": "Icon-40@2x.png", "scale": "2x"},
            {"size": "40x40", "idiom": "iphone", "filename": "Icon-40@3x.png", "scale": "3x"},
            
            # iPhone App
            {"size": "60x60", "idiom": "iphone", "filename": "Icon-60@2x.png", "scale": "2x"},
            {"size": "60x60", "idiom": "iphone", "filename": "Icon-60@3x.png", "scale": "3x"},
            
            # iPad Notifications
            {"size": "20x20", "idiom": "ipad", "filename": "Icon-20.png", "scale": "1x"},
            {"size": "20x20", "idiom": "ipad", "filename": "Icon-20@2x.png", "scale": "2x"},
            
            # iPad Settings
            {"size": "29x29", "idiom": "ipad", "filename": "Icon-29.png", "scale": "1x"},
            {"size": "29x29", "idiom": "ipad", "filename": "Icon-29@2x.png", "scale": "2x"},
            
            # iPad Spotlight
            {"size": "40x40", "idiom": "ipad", "filename": "Icon-40.png", "scale": "1x"},
            {"size": "40x40", "idiom": "ipad", "filename": "Icon-40@2x.png", "scale": "2x"},
            
            # iPad App
            {"size": "76x76", "idiom": "ipad", "filename": "Icon-76.png", "scale": "1x"},
            {"size": "76x76", "idiom": "ipad", "filename": "Icon-76@2x.png", "scale": "2x"},
            
            # iPad Pro App
            {"size": "83.5x83.5", "idiom": "ipad", "filename": "Icon-83.5@2x.png", "scale": "2x"},
            
            # App Store
            {"size": "1024x1024", "idiom": "ios-marketing", "filename": "Icon-1024.png", "scale": "1x"}
        ],
        "info": {
            "version": 1,
            "author": "xcode"
        }
    }
    
    import json
    contents_path = os.path.join(output_dir, "Contents.json")
    with open(contents_path, 'w') as f:
        json.dump(contents, f, indent=2)
    
    print(f"\n✅ 创建 Contents.json 文件")
    print("\n📝 使用说明:")
    print("1. 将整个输出文件夹拖放到 Xcode 的 Assets.xcassets 中")
    print("2. 将文件夹重命名为 'AppIcon'")
    print("3. 确保在项目设置中选择了正确的 App Icon")

if __name__ == "__main__":
    # 设置路径
    source_image = "/Users/weifu/Desktop/AIMBTI/Resources/original_icon.png"
    output_directory = "/Users/weifu/Desktop/AIMBTI/Resources/AppIcon.appiconset"
    
    # 检查源文件是否存在
    if not os.path.exists(source_image):
        print(f"❌ 找不到源图片: {source_image}")
        print("请确保原始图标已复制到正确位置")
        sys.exit(1)
    
    # 生成图标
    generate_icons(source_image, output_directory)