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
			stick: anEvent roassalShape on: self roassalShape;
			bottom;
			right;
			offset: -5 @ 20.
		self roassalShape
			when: RSShapeRemovedEvent
			do: [ anEvent roassalShape remove ]
			for: self ].
	self modelChanged
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

	^ (self model incoming , self model outgoing) asSet
]

{ #category : 'forms' }
OPBPMNSubProcessController >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : 'forms' }
OPBPMNSubProcessController >> elementsToShowInside [

	^ self model nodes
	  , (self model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'forms' }
OPBPMNSubProcessController >> modelClass [

	^ OPBPMNSubProcessModel
]

{ #category : 'forms' }
OPBPMNSubProcessController >> showDenyFeedbackFor: aController [

	^ nil
]
