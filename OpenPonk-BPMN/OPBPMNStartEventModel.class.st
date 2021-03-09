Class {
	#name : #OPBPMNStartEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNStartEventModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #accessing }
OPBPMNStartEventModel >> initialize [
	super initialize.
	type := self defaultType
]

{ #category : #accessing }
OPBPMNStartEventModel >> type [
	^ type
]

{ #category : #accessing }
OPBPMNStartEventModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
