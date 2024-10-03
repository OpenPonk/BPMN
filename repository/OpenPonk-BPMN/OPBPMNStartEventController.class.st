Class {
	#name : 'OPBPMNStartEventController',
	#superclass : 'OPBPMNEventController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNStartEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #None #Receive #Timer #Escalation #Conditional #Error #Compensation
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

	self model type = OPBPMNNodeType Timer ifTrue: [
		(aForm addDroplist: 'Timer type')
			items: #( #none #timeDate #timeDuration #timeCycle );
			display: [ :type | type asString ];
			selectItem: self model timerType;
			whenSelectedItemChangedDo: [ :newValue |
				self model timerType: newValue.
				self diagramElement modelChanged ].
		(aForm addText: 'Timer value')
			text: self model timerValue;
			whenTextChangedDo: [ :newValue |
				self model timerValue: newValue asString.
				self diagramElement modelChanged ] ]
]

{ #category : 'connecting' }
OPBPMNStartEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNStartEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ false]
			 ]
]

{ #category : 'construction' }
OPBPMNStartEventController >> diagramElementClass [

	^ OPBPMNStartEventShape
]

{ #category : 'accessing' }
OPBPMNStartEventController >> modelClass [
	^ OPBPMNStartEventModel
]
