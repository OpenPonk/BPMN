Class {
	#name : #OPBPMNMessageFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #hooks }
OPBPMNMessageFlowController >> createLineFrom: fromElement to: toElement [
	^ OPRTStyledMultiLine new
		head: self headMarker;
		tail: RTEmptyCircle;
		dashedLine;
		withBorderAttachPoint;
		color: Color black;
		edgeFrom: fromElement to: toElement
]

{ #category : #hooks }
OPBPMNMessageFlowController >> headMarker [
	^ RTSimpleArrow
]

{ #category : #hooks }
OPBPMNMessageFlowController >> modelClass [
	^ OPBPMNMessageFlowModel
]
