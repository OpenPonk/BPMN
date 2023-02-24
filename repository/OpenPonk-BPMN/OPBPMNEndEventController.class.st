Class {
	#name : #OPBPMNEndEventController,
	#superclass : #OPBPMNEventController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNEndEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Send #Link #Cancel #Error #None );
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
	(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ aController source model owner ~= self model owner ]
		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
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
	aType = OPBPMNNodeType Link
		ifTrue: [ ^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType Cancel
		ifTrue: [ ^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
