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
			self modelChanged ].
		(aForm addCheckbox: 'Is Non-Interrupting')
		state: self model isNonInterrupting;
		whenChangedDo: [ :val | 
			self model isNonInterrupting: val.
			self modelChanged ].
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeSourceFor: aController [
	^ (aController isKindOf: OPBPMNMessageFlowController) 
	| (aController isKindOf: OPBPMNFlowController)
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNMessageFlowController)
]

{ #category : 'construction' }
OPBPMNBoundaryEventController >> diagramElementClass [

	^ OPBPMNBoundaryEventShape
]

{ #category : 'forms' }
OPBPMNBoundaryEventController >> modelClass [

	^ OPBPMNBoundaryEventModel
]

{ #category : 'accessing' }
OPBPMNBoundaryEventController >> subscribeDiagram: aDiagram [

	self model subscribeDiagram: aDiagram
]
