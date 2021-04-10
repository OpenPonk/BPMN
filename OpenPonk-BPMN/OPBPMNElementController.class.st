Class {
	#name : #OPBPMNElementController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'owner'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNElementController >> createModelIn: aParentModel [
	self model: self modelClass new.
	owner := aParentModel.
	(owner isKindOf: OPBPMNPoolModel) ifTrue: [ aParentModel owner add: model ].
	aParentModel add: model.
	^ model
]

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
	(owner isKindOf: OPBPMNPoolModel) ifTrue: [ owner removeNode: self model].
	self diagramController model remove: self model.
	
	
	
	
]
