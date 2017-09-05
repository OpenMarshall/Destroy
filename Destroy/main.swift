#!/usr/bin/swift

import Foundation

func destroy() {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["ls"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    // 解析目录
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: String.Encoding.utf8),
        output.characters.count > 0 else {
        return
    }
    let fileArr = output.components(separatedBy: .newlines)
    // 遍历、替换文件
    var count = 0
    for fileName in fileArr {
        let path = task.currentDirectoryPath + fileName
        if let url = URL(string: path),
            path.contains("."),
            CommandLine.arguments.contains(url.pathExtension) {
            count += 1
            print(url)
        }
    }
    // 输出结果
    if count == 0 {
        print("😪  no file changes")
    }else if count == 1 {
        print("❣️  \(count) file destroyed")
    }else {
        print("❣️  \(count) files destroyed")
    }
}

destroy()
