Class {
	#name : #OPBPMNFlowModel,
	#superclass : #OPBPMNEdgeModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNFlowModel >> initialize [ 
	super initialize.
	type := 'Normal'
]

{ #category : #printing }
OPBPMNFlowModel >> printType [
	^ 'sequenceFlow'
]

{ #category : #printing }
OPBPMNFlowModel >> type [
	^ type
]

{ #category : #printing }
OPBPMNFlowModel >> type: aType [
	type := aType
]
