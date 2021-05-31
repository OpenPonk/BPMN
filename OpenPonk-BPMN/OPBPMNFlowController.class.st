Class {
	#name : #OPBPMNFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNFlowController >> createEdgeFrom: fromElement to: toElement [
	^ OPRTStyledMultiLine new
		head: self headShapeClass;
		withBorderAttachPoint;
		color: Color black;
		edgeFrom: fromElement to: toElement
]

{ #category : #accessing }
OPBPMNFlowController >> headShapeClass [
	^ RTSimpleArrow
]

{ #category : #accessing }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
