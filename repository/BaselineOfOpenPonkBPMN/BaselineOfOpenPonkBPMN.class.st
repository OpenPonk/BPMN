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
			with: [ spec repository: 'github://openponk/openponk:v4.1.x' ].
		spec
			baseline: 'OpenPonkModel'
			with: [
			spec repository: 'github://OpenPonk/openponk-model:v4.1.x' ].
		spec
			baseline: 'OpenPonkXMLDOMVisitor'
			with: [
			spec repository: 'github://OpenPonk/xml-dom-visitor:v4.1.x' ].
		spec
			package: 'OpenPonk-BPMN'
			with: [ spec requires: #( 'OpenPonk' 'OpenPonkModel' ) ].
		spec
			package: 'OpenPonk-BPMN-XML'
			with: [ spec requires: #( 'OpenPonk-BPMN' 'OpenPonkXMLDOMVisitor' ) ].
		spec
			package: 'OpenPonk-BPMN-Validation'
			with: [ spec requires: #( 'OpenPonk-BPMN' ) ].
		spec
			group: 'plugin'
			with:
				#( 'OpenPonk-BPMN' 'OpenPonk-BPMN-XML' 'OpenPonk-BPMN-Validation' );
			group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
