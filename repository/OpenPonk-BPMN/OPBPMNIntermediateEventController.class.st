Class {
	#name : #OPBPMNIntermediateEventController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'innerCircle',
		'elements',
		'innerConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #hooks }
OPBPMNIntermediateEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #Send #Receive #Timer #Escalation #EscalationThrow
			   #Conditional #Link #LinkThrow #Compensation #CompensationThrow
			   #Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple
			   #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
	self model type = OPBPMNNodeType Timer ifTrue: [ 
		(aForm addDroplist: 'Timer type')
			items: #( #none #timeDate #timeDuration #timeCycle );
			display: [ :type | type asString ];
			selectItem: self model timerType;
			whenSelectedItemChangedDo: [ :newValue | 
				self model timerType: newValue.
				self refreshFigure ].
		(aForm addText: 'Timer value')
			text: self model timerValue;
			whenTextChangedDo: [ :newValue | 
				self model timerValue: newValue asString.
				self refreshFigure ] ].
	self model type = OPBPMNNodeType Send
		ifTrue: [ 
			(aForm addText: 'Executable attribute')
				text: self model executableAttribute;
				whenTextChangedDo: [ :newValue | 
					self model executableAttribute: newValue asString.
					self refreshFigure ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue | 
					self model executableAttributeValue: newValue asString.
					self refreshFigure ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> diagramElementClass [

	^ OPBPMNIntermediateEventShape
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
