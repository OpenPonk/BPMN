Class {
	#name : 'OPBPMNElementController',
	#superclass : 'OPBPMNNodeController',
	#instVars : [
		'owner'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'private' }
OPBPMNElementController >> dependentElements [
	^ model flows
]

{ #category : 'connecting' }
OPBPMNElementController >> renderDiagramElement [

	super renderDiagramElement.
	model
		when: OPBPMNPlaceTokensChanged
		do: [ self diagramElement modelChanged ]
		for: self
]
