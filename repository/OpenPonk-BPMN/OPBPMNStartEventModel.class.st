Class {
	#name : #OPBPMNStartEventModel,
	#superclass : #OPBPMNEventModel,
	#instVars : [
		'isNonInterrupting'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNStartEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : #printing }
OPBPMNStartEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : #printing }
OPBPMNStartEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : #printing }
OPBPMNStartEventModel >> printType [
	^ 'startEvent'
]
