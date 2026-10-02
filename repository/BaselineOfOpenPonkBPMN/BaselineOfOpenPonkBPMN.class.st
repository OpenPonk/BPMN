"
Metacello baseline for the OpenPonk BPMN plugin, defining its package dependencies and load configurations.
"
Class {
	#name : 'BaselineOfOpenPonkBPMN',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkBPMN',
	#package : 'BaselineOfOpenPonkBPMN'
}

{ #category : 'baselines' }
BaselineOfOpenPonkBPMN >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'OpenPonk'
			with: [ spec repository: 'github://openponk/openponk:v5.0.1' ].

		spec baseline: 'OpenPonkSimulation' with: [
			spec
				repository: 'github://openponk/simulation:v5.0.1';
				loads: 'plugin' ].
		spec
			baseline: 'OpenPonkModel'
			with: [ spec repository: 'github://openponk/openponk-model:v5.0.1' ].
		spec
			baseline: 'OpenPonkXMLDOMVisitor'
			with: [ spec repository: 'github://openponk/xml-dom-visitor:v5.0.1' ].
		spec
			package: 'OpenPonk-BPMN'
			with: [ spec requires: #( 'OpenPonk' 'OpenPonkModel' ) ].
		spec
			package: 'OpenPonk-BPMN-XML'
			with: [
			spec requires: #( 'OpenPonk-BPMN' 'OpenPonkXMLDOMVisitor' ) ].
		spec
			package: 'OpenPonk-BPMN-Validation'
			with: [ spec requires: #( 'OpenPonk-BPMN' ) ].
		spec
			package: 'OpenPonk-BPMN-Simulation'
			with: [ spec requires: #( 'OpenPonk-BPMN' 'OpenPonkSimulation' ) ].
		spec
			group: 'plugin'
			with:
				#( 'OpenPonk-BPMN' 'OpenPonk-BPMN-XML' 'OpenPonk-BPMN-Validation'
				   'OpenPonk-BPMN-Simulation' );
			group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
