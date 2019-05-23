baselines
baselineOf: spec
	<baseline>
	spec
		for: #common
		do: [
			spec package: 'MQTT-Core'.
			spec package: 'MQTT-Client' with: [ spec requires: #('MQTT-Core' ) ].
			spec package: 'MQTT-Tests' with: [ spec requires: #('MQTT-Core' 'MQTT-Client' ) ].
			spec group: 'default' with: #(#'MQTT-Core' #'MQTT-Client' #'MQTT-Tests') ]