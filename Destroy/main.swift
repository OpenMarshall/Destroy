#!/usr/bin/swift

import Foundation

print("Hello, World!")

func destroy() {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["ls"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    // 解析目录
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: String.Encoding.utf8), output.characters.count > 0 else {
        return
    }
    let fileArr = output.components(separatedBy: .newlines)
    var urlArr = [URL]()
    for fileName in fileArr {
        let url = URL(string: "\(task.currentDirectoryPath)\(fileName)")!
        print(url)
        urlArr.append(url)
    }
//    print(urlArr)
}

destroy()
