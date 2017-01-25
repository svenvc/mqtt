accessing
flagBits
	| bits |
	bits := (self qualityOfService bitAnd: 2r11) << 1.
	bits := bits bitAt: 1 put: self retain asBit.
	bits := bits bitAt: 4 put: self duplicate asBit.
	^ bits 