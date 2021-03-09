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
	^ OPBPMNNodeType None
]

{ #category : #initialization }
OPBPMNActivityModel >> initialize [
	super initialize.
	type := self defaultType.
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
