//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
UIGraphicsBeginImageContext(rect.size)
var context = UIGraphicsGetCurrentContext()!

context.setFillColor(UIColor.red.cgColor)
context.fill(rect)

var image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

var dataArray = [Data?]()

var imageAsData = UIImagePNGRepresentation(image!)

dataArray.append(imageAsData)

UIGraphicsBeginImageContext(rect.size)
context = UIGraphicsGetCurrentContext()!
context.setFillColor(UIColor.red.cgColor)
context.fill(rect)

image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

imageAsData = UIImagePNGRepresentation(image!)

dataArray.append(imageAsData)