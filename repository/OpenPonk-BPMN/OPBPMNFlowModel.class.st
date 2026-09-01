"
I represent a BPMN Sequence Flow in the semantic model, establishing the structural execution sequence between flow nodes.
"
Class {
	#name : 'OPBPMNFlowModel',
	#superclass : 'OPBPMNAbstractFlowModel',
	#instVars : [
		'type'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'initialization' }
OPBPMNFlowModel >> initialize [

	super initialize.
	type := 'Normal'
]

{ #category : 'printing' }
OPBPMNFlowModel >> printType [
	^ 'sequenceFlow'
]

{ #category : 'printing' }
OPBPMNFlowModel >> type [
	^ type
]

{ #category : 'printing' }
OPBPMNFlowModel >> type: aType [
	type := aType
]
