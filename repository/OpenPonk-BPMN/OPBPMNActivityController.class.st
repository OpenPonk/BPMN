Class {
	#name : 'OPBPMNActivityController',
	#superclass : 'OPBPMNElementController',
	#instVars : [
		'labelConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNActivityController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Service #User #Manual #Send #Receive #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
	(aForm addCheckbox: 'Is Call Activity?')
		state: self model isCallActivity;
		whenChangedDo: [ :val | 
			self model isCallActivity: val.
			self diagramElement modelChanged ].
	self model type = OPBPMNNodeType Service
	| (self model type = OPBPMNNodeType Send)
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
OPBPMNActivityController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNActivityController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
]

{ #category : 'construction' }
OPBPMNActivityController >> diagramElementClass [

	^ OPBPMNActivityShape
]

{ #category : 'accessing' }
OPBPMNActivityController >> modelClass [
	^ OPBPMNActivityModel
]

{ #category : 'connecting' }
OPBPMNActivityController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
