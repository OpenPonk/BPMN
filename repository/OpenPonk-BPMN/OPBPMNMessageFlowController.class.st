Class {
	#name : 'OPBPMNMessageFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNMessageFlowController >> diagramElementClass [

	^ OPBPMNMessageFlowShape
]

{ #category : 'hooks' }
OPBPMNMessageFlowController >> modelClass [
	^ OPBPMNMessageFlowModel
]
