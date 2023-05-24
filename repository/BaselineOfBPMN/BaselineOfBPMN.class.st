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
				with: [ spec repository: 'github://openponk/openponk:dev-roassal3' ].
			spec
				baseline: 'OpenPonkModel'
				with: [ spec repository: 'github://OpenPonk/openponk-model/repository' ].
			spec
				baseline: 'XMLWriter'
				with: [ spec
						repository: 'github://pharo-contributions/XML-XMLWriter:2.9.x/src';
						loads: #(Core) ].
			spec
				package: 'OpenPonk-BPMN'
				with: [ spec requires: #('OpenPonk' 'OpenPonkModel') ].
			spec
				package: 'OpenPonk-BPMN-XML'
				with: [ spec requires: #('OpenPonk-BPMN' 'XMLWriter') ].
			spec
				package: 'OpenPonk-BPMN-Validation'
				with: [ spec requires: #('OpenPonk-BPMN') ].
			spec
				group: 'plugin' with: #('OpenPonk-BPMN' 'OpenPonk-BPMN-XML' 'OpenPonk-BPMN-Validation');
				group: 'default' with: #('OpenPonk' 'plugin') ]
]
