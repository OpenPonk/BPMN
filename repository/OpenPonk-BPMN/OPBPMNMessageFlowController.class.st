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

{ #category : #construction }
OPBPMNMessageFlowController >> diagramElementClass [

	^ OPBPMNMessageShape
]

{ #category : #hooks }
OPBPMNMessageFlowController >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : #hooks }
OPBPMNMessageFlowController >> modelClass [
	^ OPBPMNMessageFlowModel
]
