Class {
	#name : 'OPBPMNSubProcessController',
	#superclass : 'OPBPMNNodeController',
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

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ aController source model enclosingPool ~= self model enclosingPool ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
		^ aController source model isKindOf: OPBPMNDataObjectModel ].

	^ (aController isKindOf: OPBPMNElementController) or: [
		  aController isKindOf: OPBPMNEdgeController ]
]

{ #category : 'accessing' }
OPBPMNSubProcessController >> dependentElements [

	^ (self model incoming , self model outgoing) asSet
]

{ #category : 'construction' }
OPBPMNSubProcessController >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : 'accessing' }
OPBPMNSubProcessController >> elementsToShowInside [

	^ self model nodes
	  , (self model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'accessing' }
OPBPMNSubProcessController >> modelClass [

	^ OPBPMNSubProcessModel
]

{ #category : 'canvas actions' }
OPBPMNSubProcessController >> showDenyFeedbackFor: aController [

	^ nil
]
