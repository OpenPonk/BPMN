"
I represent a BPMN Message Flow in the semantic model, defining the communication paths across different pool boundaries.
"
Class {
	#name : 'OPBPMNMessageFlowModel',
	#superclass : 'OPBPMNAbstractFlowModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'printing' }
OPBPMNMessageFlowModel >> printType [
	^ 'messageFlow'
]
