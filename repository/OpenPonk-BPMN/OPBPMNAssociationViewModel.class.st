"
I am the ViewModel for BPMN Associations, mapping the association model to its UI forms and configuring its connection lifecycle.
"
Class {
	#name : 'OPBPMNAssociationViewModel',
	#superclass : 'OPBPMNEdgeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNAssociationViewModel class >> modelClass [ ^ OPBPMNAssociationModel
]

{ #category : 'construction' }
OPBPMNAssociationViewModel >> attachModelFrom: sourceViewModel to: targetViewModel [

	self model source: sourceViewModel model.
	self model target: targetViewModel model.
	sourceViewModel model addAssociation: self model.
	targetViewModel model addAssociation: self model
]

{ #category : 'private' }
OPBPMNAssociationViewModel >> basicRemoveModel [

	self model target removeAssociation: self model.
	self model source removeAssociation: self model.
	super basicRemoveModel
]

{ #category : 'forms' }
OPBPMNAssociationViewModel >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Association direction')
		items: self modelClass allAssociationDirections;
		display: [ :type | type asString ];
		selectItem: self model associationDirection;
		whenSelectedItemChangedDo: [ :newValue |
				self model associationDirection: newValue.
				self modelChanged ]
]

{ #category : 'accessing' }
OPBPMNAssociationViewModel >> icon [ ^ OPBPMNIcons accessLink16Icon
]

{ #category : 'construction' }
OPBPMNAssociationViewModel >> registerModelIn: aParentModel [

	"do nothing"
]
