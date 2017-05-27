//: Playground - noun: a place where people can play

import Foundation

var str = "Hello, playground"
var tempString = String(repeating: " ", count: 72)


tempString.remove(at: tempString.index(tempString.startIndex, offsetBy:40))
tempString.insert("O", at: tempString.index(tempString.startIndex, offsetBy:40))

print(tempString)

tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
tempString.replaceSubrange(tempString.index(tempString.startIndex, offsetBy:40)...tempString.index(tempString.startIndex, offsetBy:40), with: "O")
print(tempString)

let totalSeconds = 179
let seconds = totalSeconds % 60
let minutes = totalSeconds / 60
var temp = String(repeating: " ", count: 72)
var result = String(format:"%4d:%2d     ",minutes, seconds)


result.append(temp)
print(result)