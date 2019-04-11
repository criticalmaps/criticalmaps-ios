//
//  DarkMapOverlay.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

class DarkModeMapOverlay: MKTileOverlay {
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tileUrl = "https://a.basemaps.cartocdn.com/dark_all/\(path.z)/\(path.x)/\(path.y).png"
        return URL(string: tileUrl)!
    }
}
