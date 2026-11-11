"
I represent a BPMN Start Event in the semantic model. I initiate the process flow and track configurations such as whether the start trigger is non-interrupting.
"
Class {
	#name : 'OPBPMNStartEventModel',
	#superclass : 'OPBPMNEventModel',
	#instVars : [
		'isNonInterrupting'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'initialization' }
OPBPMNStartEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : 'accessing' }
OPBPMNStartEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : 'accessing' }
OPBPMNStartEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : 'printing' }
OPBPMNStartEventModel >> printType [
	^ 'startEvent'
]
