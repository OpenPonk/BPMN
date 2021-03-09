Class {
	#name : #OPBPMNEndEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNEndEventModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #initialization }
OPBPMNEndEventModel >> initialize [
	super initialize.
	type := self defaultType
]

{ #category : #accessing }
OPBPMNEndEventModel >> type [
	^ type
]

{ #category : #accessing }
OPBPMNEndEventModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
