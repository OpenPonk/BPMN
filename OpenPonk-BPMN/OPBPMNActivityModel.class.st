Class {
	#name : #OPBPMNActivityModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNActivityModel >> defaultType [
	^ OPBPMNActivityType Service
]

{ #category : #accessing }
OPBPMNActivityModel >> type [
	^ type
]

{ #category : #accessing }
OPBPMNActivityModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
