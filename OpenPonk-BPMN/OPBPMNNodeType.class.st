Class {
	#name : #OPBPMNNodeType,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Cancel [
	^ #Cancel
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Error [
	^ #Error
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Link [
	^ #Link
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Manual [
	^ #Manual
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> None [
	^ #None
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Receive [
	^ #Receive
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Send [
	^ #Send
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Service [
	^ #Service
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> Timer [
	^ #Timer
]

{ #category : #'as yet unclassified' }
OPBPMNNodeType class >> User [
	^#User
]
