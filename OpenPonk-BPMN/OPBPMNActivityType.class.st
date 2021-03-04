Class {
	#name : #OPBPMNActivityType,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> Manual [
	^ #Manual
]

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> None [
	^ #None
]

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> Receive [
	^ #Receive
]

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> Send [
	^ #Send
]

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> Service [
	^ #Service
]

{ #category : #'as yet unclassified' }
OPBPMNActivityType class >> User [
	^#User
]
