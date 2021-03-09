Class {
	#name : #OPBPMNIntermediateEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNIntermediateEventModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #accessing }
OPBPMNIntermediateEventModel >> initialize [
	super initialize.
	type := self defaultType
]

{ #category : #accessing }
OPBPMNIntermediateEventModel >> type [
	^ type
]

{ #category : #accessing }
OPBPMNIntermediateEventModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
