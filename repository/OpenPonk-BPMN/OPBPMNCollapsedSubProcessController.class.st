Class {
	#name : #OPBPMNCollapsedSubProcessController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'labelConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Marker')
		items: #( #None #MarkerParallel #MarkerSequential );
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
		(aForm addCheckbox: 'Is Call Activity?')
		state: self model isCallActivity;
		whenChangedDo: [ :val | 
			self model isCallActivity: val.
			self diagramElement modelChanged ].
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> dependentElements [
	^ (model incoming , model outgoing) asSet
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> diagramElementClass [

	^ OPBPMNCollapsedSubProcessShape
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> modelClass [
	^ OPBPMNCollapsedSubProcessModel
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> renderDiagramElement [

	super renderDiagramElement.
	model when: OPPlaceTokensChanged do: [ self diagramElement modelChanged ]
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> typeIconFor: aType [
	aType = OPBPMNNodeType None 
		ifTrue: [ ^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType MarkerParallel 
		ifTrue: [ ^ OPBPMNIcon current markerParallel ].
	aType = OPBPMNNodeType MarkerSequential 
		ifTrue: [ ^ OPBPMNIcon current markerSequential ]
]

{ #category : #testing }
OPBPMNCollapsedSubProcessController >> typeIconForModel [
	^ self typeIconFor: self model type
]
