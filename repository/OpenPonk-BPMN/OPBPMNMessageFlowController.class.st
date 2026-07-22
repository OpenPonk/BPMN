Class {
	#name : 'OPBPMNMessageFlowController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNMessageFlowController >> diagramElementClass [

	^ OPBPMNMessageShape
]

{ #category : 'hooks' }
OPBPMNMessageFlowController >> modelClass [
	^ OPBPMNMessageFlowModel
]
