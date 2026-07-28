Class {
	#name : 'OPBPMNIntermediateEventController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
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
				self modelChanged ].
		(aForm addText: 'Timer value')
			text: self model timerValue;
			whenTextChangedDo: [ :newValue |
				self model timerValue: newValue asString.
				self modelChanged ] ].
	self model type = OPBPMNNodeType Send
		ifTrue: [
			(aForm addText: 'Executable attribute')
				text: self model executableAttribute;
				whenTextChangedDo: [ :newValue |
					self model executableAttribute: newValue asString.
					self modelChanged ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue |
					self model executableAttributeValue: newValue asString.
					self modelChanged ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
			(aController source model isKindOf: OPBPMNDataObjectModel)
				ifFalse: [ ^ false ] ].

	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].

	^ aController source ~= self
]

{ #category : 'construction' }
OPBPMNIntermediateEventController >> diagramElementClass [

	^ OPBPMNIntermediateEventShape
]

{ #category : 'accessing' }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
