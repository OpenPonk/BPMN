Class {
	#name : 'OPBPMNSubProcessController',
	#superclass : 'OPBPMNNodeController',
	#instVars : [
		'elements'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
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
			do: [ anEvent diagramElement roassalShape remove ] ].
	self diagramElement modelChanged
]

{ #category : 'forms' }
OPBPMNSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'forms' }
OPBPMNSubProcessController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ (aController isKindOf: OPBPMNElementController)
			  | (aController isKindOf: OPBPMNEdgeController) ]
			 ]
	
]

{ #category : 'forms' }
OPBPMNSubProcessController >> dependentElements [

	^ (model incoming , model outgoing) asSet
]

{ #category : 'forms' }
OPBPMNSubProcessController >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : 'forms' }
OPBPMNSubProcessController >> elementsToShowInside [

	^ model nodes , (model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'forms' }
OPBPMNSubProcessController >> modelClass [

	^ OPBPMNSubProcessModel
]

{ #category : 'forms' }
OPBPMNSubProcessController >> removeModel [

	self diagramController model remove: self model
]

{ #category : 'forms' }
OPBPMNSubProcessController >> showDenyFeedbackFor: aController [

	^ nil
]
