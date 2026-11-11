"
I represent an expanded BPMN SubProcess in the semantic model. I act as a flow node that also functions as a container managing nested inner nodes and flows.
"
Class {
	#name : 'OPBPMNSubProcessModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'updating' }
OPBPMNSubProcessModel >> changed [

	super changed.
	owner changed
]

{ #category : 'printing' }
OPBPMNSubProcessModel >> printType [
	^ 'subProcess'
]
