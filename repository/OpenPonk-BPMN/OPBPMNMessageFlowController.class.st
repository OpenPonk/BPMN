Class {
	#name : 'OPBPMNMessageFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
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
