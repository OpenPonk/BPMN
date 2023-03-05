Class {
	#name : #OPBPMNEndEventController,
	#superclass : #OPBPMNEventController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNEndEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Send #EscalationThrow #Error #Cancel #CompensationThrow #SignalThrow #MultipleThrow #Terminate #None );
		displayIcon: [ :type | self typeIconFor: type ];
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
					self refreshFigure ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue | 
					self model executableAttributeValue: newValue asString.
					self refreshFigure ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : #connecting }
OPBPMNEndEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNMessageFlowController
]

{ #category : #connecting }
OPBPMNEndEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : #connecting }
OPBPMNEndEventController >> createRoassalShape [
	^ RTRoundedBox new
		size: 34;
		borderRadius: 17;
		color: Color transparent;
		borderColor: Color black;
		borderWidth: 5;
		yourself
]

{ #category : #construction }
OPBPMNEndEventController >> diagramElementClass [

	^ OPBPMNEndEventShape
]

{ #category : #accessing }
OPBPMNEndEventController >> modelClass [
	^ OPBPMNEndEventModel
]

{ #category : #hooks }
OPBPMNEndEventController >> typeIconFor: aType [
	aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType EscalationThrow
		ifTrue: [ ^ OPBPMNIcon current eventEscalationThrow ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Cancel
		ifTrue: [ ^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType CompensationThrow
		ifTrue: [ ^ OPBPMNIcon current eventCompensationThrow ].
	aType = OPBPMNNodeType SignalThrow
		ifTrue: [ ^ OPBPMNIcon current eventSignalThrow ].
	aType = OPBPMNNodeType MultipleThrow
		ifTrue: [ ^ OPBPMNIcon current eventMultipleThrow ].
	aType = OPBPMNNodeType Terminate 
		ifTrue: [ ^ OPBPMNIcon current eventTerminate ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
