Class {
	#name : #OPBPMNMessageShape,
	#superclass : #OPBPMNEdgeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #hooks }
OPBPMNMessageShape >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: (Color transparent);
		  yourself
]

{ #category : #hooks }
OPBPMNMessageShape >> renderBasicShape [

	^ OPRSPolyline new
		  markerEnd: self headMarker;
		  markerStart: self tailMarker;
		  dashed;
		  withBorderAttachPoint;
		  controlPointsController: OPRSPolylineCPController new;
		  addInteraction: OPRSPolylineHandles;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]

{ #category : #hooks }
OPBPMNMessageShape >> tailMarker [

	^ RSCircle new
		  size: 8;
		  border: (RSBorder new
				   color: (Color black);
				   width: 1);
		  color: (Color white);
		  yourself
]
