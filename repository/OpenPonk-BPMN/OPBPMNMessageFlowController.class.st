"
I am the controller for BPMN Message Flows. I manage the interactions and diagram logic for directed edges representing message exchanges between distinct process participants (pools).
"
Class {
	#name : 'OPBPMNMessageFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNMessageFlowController class >> diagramElementClass [

	^ OPBPMNMessageFlowShape
]

{ #category : 'accessing' }
OPBPMNMessageFlowController class >> viewModelClass [
	^ OPBPMNMessageFlowViewModel
]
