"
I am the controller for BPMN Sequence Flows. I manage the interactions and rendering of the primary directed edges dictating process execution order.
"
Class {
	#name : 'OPBPMNFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNFlowController class >> diagramElementClass [

	^ OPBPMNFlowShape
]

{ #category : 'accessing' }
OPBPMNFlowController class >> viewModelClass [
	^ OPBPMNFlowViewModel
]
