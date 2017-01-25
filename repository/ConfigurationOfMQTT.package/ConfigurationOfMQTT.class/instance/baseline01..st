baselines
baseline01: spec
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/MQTT/main/'.
		spec 
			package: 'MQTT-Client' with: [
				spec requires: #('MQTT-Core' ). ];
			package: 'MQTT-Core';
			package: 'MQTT-Tests' with: [
				spec requires: #('MQTT-Core' 'MQTT-Client' ). ].
		spec group: 'default' with: #(#'MQTT-Core' #'MQTT-Client' #'MQTT-Tests'). ].
