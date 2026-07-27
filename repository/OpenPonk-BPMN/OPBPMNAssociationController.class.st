Class {
	#name : 'OPBPMNAssociationController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'announcements' }
OPBPMNAssociationController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]

{ #category : 'accessing' }
OPBPMNAssociationController >> modelClass [

	^ OPBPMNAssociationModel
]

{ #category : 'construction' }
OPBPMNAssociationController >> registerModelInContainer: aParentModel [

	"do nothing"
]
