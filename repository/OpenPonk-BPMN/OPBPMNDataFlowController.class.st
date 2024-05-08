Class {
	#name : 'OPBPMNDataFlowController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNDataFlowController >> diagramElementClass [

	^ OPBPMNDataFlowShape
]

{ #category : 'construction' }
OPBPMNDataFlowController >> modelClass [

	^ OPBPMNDataFlowModel
]
