Class {
	#name : #OPBPMNFlowController,
	#superclass : #OPBPMNEdgeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNFlowController >> createLineFrom: fromElement to: toElement [
	^ OPRTStyledMultiLine new
		head: self headMarker;
		withBorderAttachPoint;
		color: Color black;
		edgeFrom: fromElement to: toElement
]

{ #category : #accessing }
OPBPMNFlowController >> diagramElementClass [

	^ OPBPMNFlowShape
]

{ #category : #accessing }
OPBPMNFlowController >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : #accessing }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
