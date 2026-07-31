Class {
	#name : 'OPBPMNAssociationController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNAssociationController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Association direction')
		items: self modelClass allAssociationDirections;
		display: [ :type | type asString ];
		selectItem: self model associationDirection;
		whenSelectedItemChangedDo: [ :newValue |
				self model associationDirection: newValue.
				self modelChanged ]
]

{ #category : 'construction' }
OPBPMNAssociationController >> diagramElementClass [

	^ OPBPMNAssociationShape
]

{ #category : 'accessing' }
OPBPMNAssociationController >> modelClass [

	^ OPBPMNAssociationModel
]

{ #category : 'accessing' }
OPBPMNAssociationController >> modelSource: aModel in: aParentModel [

	(super modelSource: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelSource addAssociation: self model.
	^ true
]

{ #category : 'accessing' }
OPBPMNAssociationController >> modelTarget: aModel in: aParentModel [

	(super modelTarget: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelTarget addAssociation: self model.
	^ true
]

{ #category : 'construction' }
OPBPMNAssociationController >> registerModelInContainer: aParentModel [

	"do nothing"
]

{ #category : 'destruction' }
OPBPMNAssociationController >> removeModel [

	self model owner remove: self model.
	self model target removeAssociation: self model.
	self model source removeAssociation: self model
]
