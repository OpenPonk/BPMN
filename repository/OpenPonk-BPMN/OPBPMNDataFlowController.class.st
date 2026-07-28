Class {
	#name : 'OPBPMNDataFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNDataFlowController >> diagramElementClass [

	^ OPBPMNDataFlowShape
]

{ #category : 'accessing' }
OPBPMNDataFlowController >> modelClass [

	^ OPBPMNDataFlowModel
]
