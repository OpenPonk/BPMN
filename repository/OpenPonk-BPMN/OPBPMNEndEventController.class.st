Class {
	#name : 'OPBPMNEndEventController',
	#superclass : 'OPBPMNEventController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNEndEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Send #EscalationThrow #Error #Cancel #CompensationThrow
			   #SignalThrow #MultipleThrow #Terminate #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self diagramElement modelChanged ].
	self model type = OPBPMNNodeType Send
		ifTrue: [
			(aForm addText: 'Executable attribute')
				text: self model executableAttribute;
				whenTextChangedDo: [ :newValue |
					self model executableAttribute: newValue asString.
					self diagramElement modelChanged ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue |
					self model executableAttributeValue: newValue asString.
					self diagramElement modelChanged ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : 'connecting' }
OPBPMNEndEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNMessageFlowController
]

{ #category : 'connecting' }
OPBPMNEndEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : 'construction' }
OPBPMNEndEventController >> diagramElementClass [

	^ OPBPMNEndEventShape
]

{ #category : 'accessing' }
OPBPMNEndEventController >> modelClass [
	^ OPBPMNEndEventModel
]
