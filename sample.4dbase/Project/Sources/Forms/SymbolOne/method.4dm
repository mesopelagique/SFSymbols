Case of 
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.picture:=SFSymbolPicture("lasso.sparkles")
		Form:C1466.pictureSize:=SFSymbolPicture("lasso.sparkles"; New object:C1471("width"; 64; "height"; 64))
		Form:C1466.pictureScale:=SFSymbolPicture("lasso.sparkles"; New object:C1471("scale"; 1))  // https://developer.apple.com/documentation/appkit/nsimagesymbolscale?language=objc
		Form:C1466.pictureStyle:=SFSymbolPicture("lasso.sparkles"; New object:C1471("style"; "UICTFontTextStyleTitle2"))  //  https://developer.apple.com/documentation/appkit/nsfonttextstyle?language=objc
	Else 
		
End case 