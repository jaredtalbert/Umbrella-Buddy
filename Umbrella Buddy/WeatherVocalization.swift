//
//  WeatherVocalization.swift
//  Umbrella Buddy
//
//  Created by Jared Talbert on 12/19/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import Foundation
import GameKit

class WeatherVocalization {

    let umbrellaNeededResponses: [String] = ["It looks like you need an umbrella."] // ["It's... precipitation. Grab an umbrella.", "It looks like you might need an umbrella.", "Umbrella? Definitely."]

    let umbrellaNotNeededResponses: [String] = ["You don\'t need an umbrella."] // ["It's dry as a bone. No umbrella needed.", "Don't forget your wallet, keys, and phone. Forget the umbrella, though.", "No rain in sight. Leave the umbrella behind."]

    func giveVocalization(isUmbrellaNeeded: Bool) -> String {
        if (isUmbrellaNeeded) {
            let randomIndex: Int = Int.random(in: 0..<umbrellaNeededResponses.count)
            return umbrellaNeededResponses[randomIndex]
        }
        else {
            let randomIndex: Int = Int.random(in: 0 ..< umbrellaNotNeededResponses.count)
            return umbrellaNotNeededResponses[randomIndex]
        }
    }
}
