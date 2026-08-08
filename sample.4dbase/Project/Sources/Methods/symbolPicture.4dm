//%attributes = {}
#DECLARE($item : Object)->$picture : Picture

// Lazily render one symbol for the list box: called per displayed row by the Picture
// column's expression, so the 8000-symbol list loads instantly instead of rendering
// every picture up front.
//
// Use the symbol's own colors when it actually has a multicolor variant (see
// $item.multicolor from Resources/symbols.json); otherwise render a plain symbol that
// follows the window's Light/Dark appearance ("multicolor" would pin it to one fixed
// color and ignore Dark mode).
var $options : Object
If (Bool:C1537($item.multicolor))
	$options:={multicolor: True:C214; window: Current form window:C827}
Else 
	$options:={window: Current form window:C827}
End if 

$picture:=SFSymbolPicture($item.name; $options)
