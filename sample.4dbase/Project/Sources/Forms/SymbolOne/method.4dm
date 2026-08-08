Case of 
	: (Form event code:C388=On Load:K2:1)
		
		// A plain symbol adapts to the appearance (Dark/Light). Pass "window" so it
		// matches this form's window specifically, instead of the whole application.
		Form:C1466.picture:=SFSymbolPicture("lasso.sparkles"; {window: Current form window:C827})
		Form:C1466.pictureSize:=SFSymbolPicture("lasso.sparkles"; {width: 64; height: 64})
		Form:C1466.pictureScale:=SFSymbolPicture("lasso.sparkles"; {scale: 1})  // https://developer.apple.com/documentation/appkit/nsimagesymbolscale?language=objc
		Form:C1466.pictureStyle:=SFSymbolPicture("lasso.sparkles"; {style: "UICTFontTextStyleTitle2"})  //  https://developer.apple.com/documentation/appkit/nsfonttextstyle?language=objc
		
		// New rendering options available since macOS Big Sur (safely ignored on older systems)
		
		// Hierarchical (macOS 12+): one color, layers get automatic opacity levels
		Form:C1466.pictureHierarchical:=SFSymbolPicture("square.stack.3d.up.fill"; {width: 64; height: 64; hierarchicalColor: "#0A84FF"})
		
		// Palette (macOS 12+): one color per layer, pass a collection of hex strings
		Form:C1466.picturePalette:=SFSymbolPicture("person.crop.circle.badge.plus"; {width: 64; height: 64; paletteColors: ["#FF375F"; "#30D158"]})
		
		// Multicolor (macOS 12+): use the symbol's own predefined colors
		// (pick a symbol that actually has a multicolor variant, e.g. cloud.sun.rain.fill)
		Form:C1466.pictureMulticolor:=SFSymbolPicture("cloud.sun.rain.fill"; {width: 64; height: 64c})
		
		// Monochrome (macOS 13+): render every layer in a single color
		Form:C1466.pictureMonochrome:=SFSymbolPicture("heart.fill"; {width: 64; height: 64; monochrome: True:C214})
		
		// Variable value (macOS 13+): fill level 0.0 - 1.0 for symbols that support it
		Form:C1466.pictureVariable:=SFSymbolPicture("wifi"; {width: 64; height: 64; variableValue: 0.4})
		
		// Explicit tint color for a plain symbol. Without "color", a plain symbol
		// follows the current appearance (black in Light, white in Dark mode).
		Form:C1466.pictureColor:=SFSymbolPicture("gear"; {width: 64; height: 64; color: "#FF9500"})
		
	Else 
		
End case 
