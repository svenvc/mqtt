accessing
subscriptions
	^ subscriptions ifNil: [ subscriptions := OrderedCollection new ]