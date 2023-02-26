Class {
	#name : #OPBPMNFlowShape,
	#superclass : #OPBPMNEdgeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> renderBasicShape [

	^ OPRSPolyline new
		  markerEnd: self headMarker;
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
