reading
readInt16From: byteStream
	^ (byteStream next << 8) + byteStream next