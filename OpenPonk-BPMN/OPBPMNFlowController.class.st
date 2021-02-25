Class {
	#name : #OPBPMNFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNFlowController >> headShapeClass [
	^ RTSimpleArrow
]

{ #category : #accessing }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
