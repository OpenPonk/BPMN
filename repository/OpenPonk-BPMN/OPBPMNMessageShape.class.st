Class {
	#name : 'OPBPMNMessageShape',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
}

{ #category : 'hooks' }
OPBPMNMessageShape >> borderColor: aColor [

	self roassalShape color: aColor
]

{ #category : 'initialization' }
OPBPMNMessageShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	OPBPMNEdgeLabel in: self
]

{ #category : 'hooks' }
OPBPMNMessageShape >> headMarker [

	^ (RSShapeFactory polygonWithPoints: (Array
				    with: 5 @ 10
				    with: 0 @ 5
				    with: -5 @ 10
				    with: 0 @ 0))
		  color: (Color transparent);
		  yourself
]

{ #category : 'rendering' }
OPBPMNMessageShape >> renderBasicShape [

	^ OPRSPolyline new
		  markerEnd: self headMarker;
		  markerStart: self tailMarker;
		  dashed;
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]

{ #category : 'hooks' }
OPBPMNMessageShape >> tailMarker [

	^ RSCircle new
		  size: 8;
		  border: (RSBorder new
				   color: (Color black);
				   width: 1);
		  color: (Color white);
		  yourself
]
