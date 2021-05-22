# SFSymbols

[![build](https://github.com/mesopelagique/SFSymbols/actions/workflows/build.yml/badge.svg)](https://github.com/mesopelagique/SFSymbols/actions/workflows/build.yml)
[![release](https://github.com/mesopelagique/SFSymbols/actions/workflows/release.yml/badge.svg)](https://github.com/mesopelagique/SFSymbols/actions/workflows/release.yml)
[![release](https://img.shields.io/github/v/release/mesopelagique/SFSymbols.svg)](https://github.com/mesopelagique/SFSymbols/releases/latest)

⚠️ Only available on macOS Bigsur

Use on macOS [SF Symbols](https://developer.apple.com/sf-symbols/)
 
![All.png](All.png)

## How to use

```4d
$picture:=SFSymbolPicture("lasso.sparkles")
```

You could also set size

```4d
$picture:=SFSymbolPicture("lasso.sparkles"; New object("width"; 64; "height"; 64))
```

## Get a list of available icons

Download the recommended app from [apple site](https://developer.apple.com/sf-symbols/) or you could look at the [demo app resources](https://github.com/mesopelagique/SFSymbols/blob/main/sample.4dbase/Resources/list.txt)

## Install

Compile the projet and put `SFSymbols.bundle` into your database or app [Plugins folder](sample.4dbase/Plugins/).

You could also download [the latest release](https://github.com/mesopelagique/SFSymbols/releases/latest/download/SFSymbols.bundle.zip) but it is maybe not well signed or compiled for apple M1
