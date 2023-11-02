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
				with: [ spec repository: 'github://openponk/openponk' ].
			spec
				baseline: 'OpenPonkModel'
				with: [ spec repository: 'github://OpenPonk/openponk-model/repository' ].
			spec
				package: 'OpenPonk-BPMN'
				with: [ spec requires: #('OpenPonk' 'OpenPonkModel') ].
			spec
				package: 'OpenPonk-BPMN-XML'
				with: [ spec requires: #('OpenPonk-BPMN') ].
			spec
				package: 'OpenPonk-BPMN-Validation'
				with: [ spec requires: #('OpenPonk-BPMN') ].
			spec
				group: 'plugin' with: #('OpenPonk-BPMN' 'OpenPonk-BPMN-XML' 'OpenPonk-BPMN-Validation');
				group: 'default' with: #('OpenPonk' 'plugin') ]
]
