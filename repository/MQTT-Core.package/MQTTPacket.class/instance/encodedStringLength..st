writing
encodedStringLength: string
	^ 2 + (ZnCharacterEncoder utf8 encodedByteCountForString: string)