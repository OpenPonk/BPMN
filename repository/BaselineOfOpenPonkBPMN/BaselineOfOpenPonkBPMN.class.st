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
			with: [ spec repository: 'github://OpenPonk/openponk' ].

		spec baseline: 'OpenPonkSimulation' with: [
			spec
				repository: 'github://OpenPonk/simulation';
				loads: 'plugin' ].
		spec
			baseline: 'OpenPonkModel'
			with: [ spec repository: 'github://OpenPonk/openponk-model' ].
		spec
			baseline: 'OpenPonkXMLDOMVisitor'
			with: [ spec repository: 'github://OpenPonk/xml-dom-visitor' ].
		spec
			package: 'OpenPonk-BPMN'
			with: [ spec requires: #( 'OpenPonk' 'OpenPonkModel' ) ].
		spec
			package: 'OpenPonk-BPMN-Tests'
			with: [ spec requires: #( 'OpenPonk-BPMN' ) ].
		spec
			package: 'OpenPonk-BPMN-XML'
			with: [
			spec requires: #( 'OpenPonk-BPMN' 'OpenPonkXMLDOMVisitor' ) ].
		spec
			package: 'OpenPonk-BPMN-XML-Tests'
			with: [ spec requires: #( 'OpenPonk-BPMN-XML' ) ].
		spec
			package: 'OpenPonk-BPMN-Validation'
			with: [ spec requires: #( 'OpenPonk-BPMN' ) ].
		spec
			package: 'OpenPonk-BPMN-Validation-Tests'
			with: [ spec requires: #( 'OpenPonk-BPMN-Validation' ) ].
		spec
			package: 'OpenPonk-BPMN-Simulation'
			with: [ spec requires: #( 'OpenPonk-BPMN' 'OpenPonkSimulation' ) ].
		spec
			package: 'OpenPonk-BPMN-Simulation-Tests'
			with: [ spec requires: #( 'OpenPonk-BPMN-Simulation' ) ].
		spec
			group: 'plugin'
			with:
				#( 'OpenPonk-BPMN' 'OpenPonk-BPMN-Tests' 'OpenPonk-BPMN-XML' 'OpenPonk-BPMN-XML-Tests'
				   'OpenPonk-BPMN-Validation' 'OpenPonk-BPMN-Validation-Tests'
				   'OpenPonk-BPMN-Simulation' 'OpenPonk-BPMN-Simulation-Tests' );
			group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
