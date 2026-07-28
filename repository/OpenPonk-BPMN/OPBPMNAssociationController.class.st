Class {
	#name : 'OPBPMNAssociationController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNAssociationController >> diagramElementClass [

	^ OPBPMNAssociationShape
]

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
