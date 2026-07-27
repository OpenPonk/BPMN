Class {
	#name : 'OPBPMNAbstractFlowController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'announcements' }
OPBPMNAbstractFlowController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]

{ #category : 'construction' }
OPBPMNAbstractFlowController >> modelSource: aModel in: aParentModel [

	(super modelSource: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelSource addFlow: self model.
	^ true
]

{ #category : 'construction' }
OPBPMNAbstractFlowController >> modelTarget: aModel in: aParentModel [

	(super modelTarget: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelTarget addFlow: self model.
	^ true
]

{ #category : 'construction' }
OPBPMNAbstractFlowController >> registerModelInContainer: aParentModel [

	"do nothing"
]

{ #category : 'destruction' }
OPBPMNAbstractFlowController >> removeModel [
	self model owner remove: self model.
	self model target removeFlow: self model.
	self model source removeFlow: self model
]
