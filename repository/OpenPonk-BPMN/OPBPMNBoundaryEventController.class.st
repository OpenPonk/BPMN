Class {
	#name : 'OPBPMNBoundaryEventController',
	#superclass : 'OPBPMNElementController',
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNBoundaryEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation
			   #Signal #Multiple #ParallelMultiple );
		displayIcon: [ :type | self model typeIconFor: type ];
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

{ #category : 'forms' }
OPBPMNBoundaryEventController >> canBeSourceFor: aController [
	^ (aController isKindOf: OPBPMNMessageFlowController) 
	| (aController isKindOf: OPBPMNFlowController)
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNMessageFlowController)
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> diagramElementClass [

	^ OPBPMNBoundaryEventShape
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> modelClass [

	^ OPBPMNBoundaryEventModel
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> removeModel [

	self diagramController model remove: self model
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> subscribeDiagram: aDiagram [

	self model subscribeDiagram: aDiagram
]
