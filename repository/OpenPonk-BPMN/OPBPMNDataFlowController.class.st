"
I am the controller for BPMN Data Associations. I manage the interactions and diagram logic for directed edges connecting data objects to activities.
"
Class {
	#name : 'OPBPMNDataFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNDataFlowController class >> diagramElementClass [

	^ OPBPMNDataFlowShape
]

{ #category : 'accessing' }
OPBPMNDataFlowController class >> viewModelClass [
	^ OPBPMNDataFlowViewModel
]
