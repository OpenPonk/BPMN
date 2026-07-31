Class {
	#name : 'OPBPMNEdgeController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'announcements' }
OPBPMNEdgeController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]
