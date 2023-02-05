Class {
	#name : #OPBPMNElementController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'owner'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNElementController >> createRoassalShape [
	^ self subclassResponsibility
]

{ #category : #private }
OPBPMNElementController >> dependentElements [
	^ model flows
]

{ #category : #connecting }
OPBPMNElementController >> removeFigure [
	owner := self model owner.
	super removeFigure.
	(owner isKindOf: OPBPMNPoolModel) ifTrue: [ owner removeNode: self model]
	
]
