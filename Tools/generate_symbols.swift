// generate_symbols.swift
//
// Regenerates sample.4dbase/Resources/symbols.json — the single source of truth for
// the demo: every SF Symbol in Apple's browse order, each tagged with whether it
// renders with real colors under `{multicolor: True}`.
//
// COMPLETE LIST + ORDER
// ---------------------
// Apple ships both on every Mac, in the CoreGlyphs bundle:
//   /System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources/
//     symbol_order.plist        -> the SF Symbols app browse order (array of names)
//     name_availability.plist   -> every name -> the OS release it appeared in
// We drive the list (and its order) from symbol_order.plist.
//
// MULTICOLOR FLAG
// ---------------
// Apple's asset flag "Contains Multicolor Layers" is True for ~every symbol, so it
// can't tell real multicolor symbols apart. The reliable signal is to render the
// symbol exactly the way the plugin does (NSImage + configurationPreferringMulticolor,
// non-template) and check whether the pixels are actually chromatic. multicolor=true
// means {multicolor: True} shows the symbol's own colors; false means it falls back
// to a single template color (so the demo uses {window: ...} instead, which adapts
// to Dark mode).
//
// USAGE
//   swift Tools/generate_symbols.swift sample.4dbase/Resources/symbols.json
// Results depend on the macOS version (recorded in "generatedWith"). macOS only.

import AppKit
import Foundation

let res = "/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources"
let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "sample.4dbase/Resources/symbols.json"
let pointSize: CGFloat = 44
let satThreshold = 0.20   // measured: real multicolor 0.58..1.0, monochrome 0..0.06

// SF Symbols ships localized script variants of many symbols (e.g. "0.circle.ar",
// "1.square.hi") — near-duplicate Arabic / Devanagari / CJK forms of the same glyph.
// They add hundreds of look-alike rows, so we drop them (set to false to keep them).
let excludeLocalized = true
let scriptCodes: Set<String> = ["ar","hi","he","th","zh","ja","ko","bn","gu","pa","kn","ml","or","te","si","ta","km","my"]

NSApplication.shared.setActivationPolicy(.prohibited)

func plistArray(_ file: String) -> [String] {
    guard let data = FileManager.default.contents(atPath: res + "/" + file),
          let arr = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String]
    else { return [] }
    return arr
}
func plistSymbolsDict(_ file: String) -> [String] {
    guard let data = FileManager.default.contents(atPath: res + "/" + file),
          let d = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
          let syms = d["symbols"] as? [String: Any] else { return [] }
    return Array(syms.keys)
}

// The full, ordered, de-duplicated name list, sourced only from Apple's CoreGlyphs
// plists (so this stays reproducible after list.txt is gone):
//   - symbol_order.plist       -> Apple browse order (primary)
//   - name_availability.plist  -> catches symbols missing from symbol_order
//                                 (restricted/legacy names like applelogo, airplayaudio)
// Extras not in symbol_order are appended, sorted, after the ordered set.
func allNames() -> [String] {
    let order = plistArray("symbol_order.plist")
    let avail = plistSymbolsDict("name_availability.plist")
    let known = Set(order).union(avail)
    func isLocalized(_ n: String) -> Bool {
        guard excludeLocalized else { return false }
        let parts = n.split(separator: ".")
        guard parts.count >= 2, let last = parts.last, scriptCodes.contains(String(last)) else { return false }
        return known.contains(parts.dropLast().joined(separator: "."))   // base glyph exists -> it's a variant
    }
    var seen = Set<String>()
    var result: [String] = []
    for n in order where !isLocalized(n) {
        if seen.insert(n).inserted { result.append(n) }
    }
    for n in avail.sorted() where !isLocalized(n) {
        if seen.insert(n).inserted { result.append(n) }
    }
    return result
}

// true = renders chromatic (multicolor), false = monochrome fallback, nil = not available on this OS
func supportsMulticolor(_ name: String) -> Bool? {
    guard let base = NSImage(systemSymbolName: name, accessibilityDescription: nil) else { return nil }
    let cfg = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
        .applying(.preferringMulticolor())
    guard let img = base.withSymbolConfiguration(cfg) else { return nil }
    let dim = Int(pointSize) + 16
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: dim, pixelsHigh: dim,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0),
        let ctx = NSGraphicsContext(bitmapImageRep: rep) else { return nil }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = ctx
    NSColor.clear.set(); NSRect(x: 0, y: 0, width: dim, height: dim).fill()
    let s = img.size
    img.draw(in: NSRect(x: (CGFloat(dim)-s.width)/2, y: (CGFloat(dim)-s.height)/2, width: s.width, height: s.height))
    NSGraphicsContext.restoreGraphicsState()
    guard let px = rep.bitmapData else { return false }
    let bpr = rep.bytesPerRow
    for y in 0..<dim {
        let row = px + y * bpr
        for x in 0..<dim {
            let p = row + x * 4
            if CGFloat(p[3]) / 255.0 < 0.35 { continue }
            let r = CGFloat(p[0]) / 255.0, g = CGFloat(p[1]) / 255.0, b = CGFloat(p[2]) / 255.0
            let mx = max(r, g, b), mn = min(r, g, b)
            if mx < 0.08 { continue }                    // near-black, ignore
            if Double((mx - mn) / mx) >= satThreshold { return true }
        }
    }
    return false
}

let names = allNames()
var symbols: [[String: Any]] = []
var multi = 0, unavailable = 0
let start = Date()
for name in names {
    switch supportsMulticolor(name) {
    case .some(let mc):
        symbols.append(["name": name, "multicolor": mc])
        if mc { multi += 1 }
    case .none:
        unavailable += 1   // not available on this OS; skip so the demo never shows a blank
    }
}

let os = ProcessInfo.processInfo.operatingSystemVersion
let out: [String: Any] = [
    "generatedWith": "macOS \(os.majorVersion).\(os.minorVersion) (CoreGlyphs)",
    "note": "Symbols in Apple browse order. multicolor=true: SFSymbolPicture(name; {multicolor: True}) renders the symbol's own colors. false: it falls back to a single template color, so use {color: ...} or {window: ...} (adapts to Dark mode) instead.",
    "counts": ["total": symbols.count, "multicolor": multi, "monochrome": symbols.count - multi, "unavailableOnThisOS": unavailable],
    "symbols": symbols
]
// Keep "symbols" array in Apple order: do NOT sort keys of the array elements' order,
// but pretty-print. (sortedKeys only affects dictionary key order, not array order.)
let jdata = try! JSONSerialization.data(withJSONObject: out, options: [.prettyPrinted, .sortedKeys])
try! jdata.write(to: URL(fileURLWithPath: outPath))
FileHandle.standardError.write("wrote \(outPath): total=\(symbols.count) multicolor=\(multi) mono=\(symbols.count-multi) unavailable=\(unavailable) in \(String(format: "%.1f", Date().timeIntervalSince(start)))s\n".data(using: .utf8)!)
