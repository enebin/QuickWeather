import Combine
import SwiftUI

var x = "H"
let pubpub = PassthroughSubject<String, Never>()
let xPub = x.publisher

x = "I"
pubpub.send("I")

var subscriptions = Set<AnyCancellable>()
DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    x.publisher
        .sink { string in
            print("It's X \(string)")
        }
        .store(in: &subscriptions)
    
    pubpub
        .sink { string in
            print("Hahaha \(string)")
        }
        .store(in: &subscriptions)
})

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    x = "P"
    pubpub.send("P")
}


DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    pubpub.send("O")
}

//sub.cancel()

pubpub.send("DDD")
print("WASSUP")
