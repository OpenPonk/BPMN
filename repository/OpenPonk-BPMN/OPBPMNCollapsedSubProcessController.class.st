Class {
	#name : 'OPBPMNCollapsedSubProcessController',
	#superclass : 'OPBPMNElementController',
	#instVars : [
		'labelConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNCollapsedSubProcessController >> buildEditorForm: aForm [

	| anEvent |
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Marker')
		items:
			#( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation
			   #MarkerAdhoc );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self modelChanged ].
	(aForm addCheckbox: 'Is Call Activity?')
		state: self model isCallActivity;
		whenChangedDo: [ :val |
			self model isCallActivity: val.
			self modelChanged ].

	(aForm addButton: 'Add Boundary Event') action: [
		anEvent := OPBPMNBoundaryEventController new
			           createModelIn: self model;
			           showInDiagram: self diagramController;
			           subscribeDiagram: self diagramElement;
			           yourself.
		"self diagramElement addBoundaryEvent: anEvent"
		RSLocation new
			stick: anEvent diagramElement roassalShape
			on: self roassalShape;
			bottom;
			right;
			offset: -1 @ 22.
		self diagramElement roassalShape
			when: RSShapeRemovedEvent
			do: [ anEvent roassalShape remove ]
			for: self ].
	self modelChanged
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : 'construction' }
OPBPMNCollapsedSubProcessController >> diagramElementClass [

	^ OPBPMNCollapsedSubProcessShape
]

{ #category : 'construction' }
OPBPMNCollapsedSubProcessController >> modelClass [
	^ OPBPMNCollapsedSubProcessModel
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
