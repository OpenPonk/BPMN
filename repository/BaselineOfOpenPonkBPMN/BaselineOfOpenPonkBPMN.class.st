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
			with: [ spec repository: 'github://openponk/openponk' ].

		spec baseline: 'OpenPonkSimulation' with: [
			spec
				repository: 'github://openponk/simulation';
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
