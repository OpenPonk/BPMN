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
OPBPMNElementController >> refreshFigure [
	figure update.
	^ super refreshFigure
]

{ #category : #connecting }
OPBPMNElementController >> removeFigure [
	super removeFigure
]

{ #category : #connecting }
OPBPMNElementController >> removeModel [
	self diagramController model remove: self model.
	self model owner removeNode: self model
]
