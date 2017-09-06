#!/usr/bin/swift

import Foundation

func destroy() {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["ls"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    // parse directory
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: String.Encoding.utf8),
        output.characters.count > 0 else {
        return
    }
    let fileArr = output.components(separatedBy: .newlines)
    // find file
    var count = 0
    for fileName in fileArr {
        guard fileName.characters.count > 0 else {
            continue
        }
        let path = task.currentDirectoryPath + "/" + fileName
        guard let url = URL(string: path), path.contains(".") else {
            continue
        }
        if CommandLine.arguments.contains(url.pathExtension) || CommandLine.arguments.last == "all" {
            count += 1
            print(url.lastPathComponent)
            // destory
            do {
                try FileManager.default.removeItem(at: url)
            } catch {}
            FileManager.default.createFile(atPath: url.path,
                                           contents: Data(repeating: 20, count: 20), // whatever
                                           attributes: nil)
        }
    }
    // log result
    if count == 0 {
        print("😪  no file changes")
    }else if count == 1 {
        print("❣️  \(count) file destroyed")
    }else {
        print("❣️  \(count) files destroyed")
    }
}

destroy()
