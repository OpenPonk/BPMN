"
I represent a BPMN Data Association in the semantic model, defining the directed flow of data into or out of flow nodes.
"
Class {
	#name : 'OPBPMNDataFlowModel',
	#superclass : 'OPBPMNAbstractFlowModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNDataFlowModel >> associationDirection [
	^ 'One'
]

{ #category : 'printing' }
OPBPMNDataFlowModel >> printType [
	^ 'association'
]
