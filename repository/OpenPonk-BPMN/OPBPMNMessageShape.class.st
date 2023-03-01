Class {
	#name : #OPBPMNMessageShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #hooks }
OPBPMNMessageShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	"self ownedElements
		detect: [ :any | any isKindOf: OPBPMNEdgeLabel  ]
		ifFound: [ ^ self ].
	OPBPMNEdgeLabel in: self forModelElement: self modelElement"
	OPBPMNMessageShape in: self
]

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
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
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
