Class {
	#name : 'OPBPMNDataObjectController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNDataObjectController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #DataObject #DataInput #DataOutput #DataStore);
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNDataFlowController
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNDataFlowController
]

{ #category : 'accessing' }
OPBPMNDataObjectController >> dependentElements [
	^ (model incoming , model outgoing) asSet
]

{ #category : 'construction' }
OPBPMNDataObjectController >> diagramElementClass [

	^ OPBPMNDataObjectShape
]

{ #category : 'announcements' }
OPBPMNDataObjectController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel
		when: OPBPMNPlaceTokensChanged
		send: #modelChanged
		to: self
]

{ #category : 'accessing' }
OPBPMNDataObjectController >> modelClass [
	^ OPBPMNDataObjectModel
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> typeIconFor: aType [
	aType = OPBPMNNodeType DataObject
		ifTrue: [ ^ OPBPMNIcon current dataObject16 ].
	aType = OPBPMNNodeType DataInput
		ifTrue: [ ^ OPBPMNIcon current dataInput16 ].
	aType = OPBPMNNodeType DataOutput
		ifTrue: [ ^ OPBPMNIcon current dataOutput16 ].
	aType = OPBPMNNodeType DataStore
		ifTrue: [ ^ OPBPMNIcon current dataStore16 ].
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
