Class {
	#name : #OPBPMNBoundaryEventController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #forms }
OPBPMNBoundaryEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation
			   #Signal #Multiple #ParallelMultiple );
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
		(aForm addCheckbox: 'Is Non-Interrupting')
		state: self model isNonInterrupting;
		whenChangedDo: [ :val | 
			self model isNonInterrupting: val.
			self diagramElement modelChanged ].
]

{ #category : #forms }
OPBPMNBoundaryEventController >> canBeSourceFor: aController [
	^ (aController isKindOf: OPBPMNMessageFlowController) 
	| (aController isKindOf: OPBPMNFlowController)
]

{ #category : #forms }
OPBPMNBoundaryEventController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNMessageFlowController)
]

{ #category : #forms }
OPBPMNBoundaryEventController >> diagramElementClass [

	^ OPBPMNBoundaryEventShape
]

{ #category : #forms }
OPBPMNBoundaryEventController >> modelClass [

	^ OPBPMNBoundaryEventModel
]

{ #category : #forms }
OPBPMNBoundaryEventController >> removeModel [

	self diagramController model remove: self model
]

{ #category : #forms }
OPBPMNBoundaryEventController >> subscribeDiagram: aDiagram [

	self model subscribeDiagram: aDiagram
]

{ #category : #forms }
OPBPMNBoundaryEventController >> typeIconFor: aType [

	aType = OPBPMNNodeType Receive ifTrue: [ 
		^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ 
		^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ 
		^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional ifTrue: [ 
		^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [ 
		^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Cancel ifTrue: [ 
		^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Compensation ifTrue: [ 
		^ OPBPMNIcon current eventCompensation ].
	aType = OPBPMNNodeType Signal ifTrue: [ 
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple ifTrue: [ 
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ 
		^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType CatchCompensation ifTrue: [ 
		^ OPBPMNIcon current eventCatchCompensation ]
]
