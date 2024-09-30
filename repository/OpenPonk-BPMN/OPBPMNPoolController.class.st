Class {
	#name : 'OPBPMNPoolController',
	#superclass : 'OPBPMNNodeController',
	#instVars : [
		'innerBox',
		'innerConstraint',
		'labeled',
		'labelConstraint',
		'elements'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNPoolController >> boxHeight [
	^ 300
]

{ #category : 'connecting' }
OPBPMNPoolController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addTextInput: 'Lanes')
		text: self model lanes asString;
		whenTextChangedDo: [ :newValue | 
			self model lanes: (newValue asString asInteger ifNil: [ 1 ]).
			self model laneNamesFitToLanesCount.
			self diagramElement modelChanged ].

	self model lanes > 1 ifTrue: [ 
		1 to: self model lanes do: [ :i | 
			(aForm addTextInput: 'Lane ', i asString)
				text: (self model laneNames at: i) asString;
				whenTextChangedDo: [ :newValue | 
					self model laneNamesAt: i put: newValue.
					self diagramElement modelChanged ] ] ]
]

{ #category : 'connecting' }
OPBPMNPoolController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNMessageFlowController
]

{ #category : 'connecting' }
OPBPMNPoolController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ (aController source model owner ~= self model) ]
		ifFalse: [ ^ (aController isKindOf: OPBPMNElementController)
				| (aController isKindOf: OPBPMNSubProcessController)
				| (aController isKindOf: OPBPMNDataObjectController)]
]

{ #category : 'connecting' }
OPBPMNPoolController >> diagramElementClass [

	^ OPBPMNPoolShape
]

{ #category : 'connecting' }
OPBPMNPoolController >> elementsToShowInside [
	^ model nodes , (model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'accessing' }
OPBPMNPoolController >> modelClass [
	^ OPBPMNPoolModel
]

{ #category : 'connecting' }
OPBPMNPoolController >> showDenyFeedbackFor: aController [
	^ nil
]
