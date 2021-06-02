Class {
	#name : #BaselineOfBPMN,
	#superclass : #BaselineOf,
	#category : #BaselineOfBPMN
}

{ #category : #baselines }
BaselineOfBPMN >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'OpenPonk'
				with: [ spec repository: 'github://openponk/openponk/repository' ].
			spec
				package: 'OpenPonk-BPMN'
				with: [ spec repository: 'github://primudav/OpenPonk-BPMN' ].
			spec
				package: 'OpenPonk-BPMN-XML'
				with: [ spec requires: #('OpenPonk-BPMN') ].
			spec
				group: 'plugin' with: #('OpenPonk-BPMN' 'OpenPonk-BPMN-XML');
				group: 'default' with: #('OpenPonk' 'plugin') ]
]
