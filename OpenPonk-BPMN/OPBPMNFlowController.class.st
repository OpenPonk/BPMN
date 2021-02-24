Class {
	#name : #OPBPMNFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNFlowController >> headShapeClass [
	^ RTEmptyCircle
]

{ #category : #accessing }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
