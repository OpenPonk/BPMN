Class {
	#name : #OPBPMNSubProcessController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'elements'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #private }
OPBPMNSubProcessController >> buildEditorForm: aForm [

	| anEvent |
	super buildEditorForm: aForm.
	(aForm addButton: 'Add Boundary Event') action: [ 
		anEvent := OPBPMNBoundaryEventController new
			           createModelIn: self model;
			           showInDiagram: self diagramController;
			           subscribeDiagram: self diagramElement;
			           yourself.
		"self diagramElement addBoundaryEvent: anEvent"
		RSLocation new
			stick: anEvent diagramElement roassalShape
			on: self diagramElement roassalShape;
			bottom;
			right;
			offset: -5 @ 20.
		self diagramElement roassalShape
			when: RSShapeRemovedEvent
			do: [ anEvent diagramElement roassalShape remove ] ]
]

{ #category : #private }
OPBPMNSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #private }
OPBPMNSubProcessController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ aController source model owner ~= self model ]
		ifFalse: [ ^ (aController isKindOf: OPBPMNElementController)
						| (aController isKindOf: OPBPMNEdgeController) ]
]

{ #category : #private }
OPBPMNSubProcessController >> dependentElements [

	^ (model incoming , model outgoing) asSet
]

{ #category : #private }
OPBPMNSubProcessController >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : #private }
OPBPMNSubProcessController >> elementsToShowInside [

	^ model nodes , (model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : #private }
OPBPMNSubProcessController >> modelClass [

	^ OPBPMNSubProcessModel 
]

{ #category : #private }
OPBPMNSubProcessController >> removeModel [

	self diagramController model remove: self model
]

{ #category : #private }
OPBPMNSubProcessController >> showDenyFeedbackFor: aController [

	^ nil
]
