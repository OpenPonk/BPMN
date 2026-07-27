Class {
	#name : 'OPBPMNDataObjectController',
	#superclass : 'OPBPMNSemanticNodeController',
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
			self modelChanged ].
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNDataFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeTargetFor: aController [

	^ ((aController isKindOf: OPBPMNDataFlowController) or: [
		   aController isKindOf: OPBPMNAssociationController ]) and: [
		  aController source ~= self ]
]

{ #category : 'construction' }
OPBPMNDataObjectController >> diagramElementClass [

	^ OPBPMNDataObjectShape
]

{ #category : 'announcements' }
OPBPMNDataObjectController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel
		weakWhen: OPBPMNPlaceTokensChanged
		send: #modelChanged
		to: self
]

{ #category : 'accessing' }
OPBPMNDataObjectController >> modelClass [
	^ OPBPMNDataObjectModel
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> typeIconFor: aType [

	aType = OPBPMNNodeType DataObject ifTrue: [
		^ OPBPMNIcon current dataObject16 ].
	aType = OPBPMNNodeType DataInput ifTrue: [
		^ OPBPMNIcon current dataInput16 ].
	aType = OPBPMNNodeType DataOutput ifTrue: [
		^ OPBPMNIcon current dataOutput16 ].
	aType = OPBPMNNodeType DataStore ifTrue: [
		^ OPBPMNIcon current dataStore16 ].
	self error: 'Unknown type'
]
