Class {
	#name : #OPBPMNFlowShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	"self ownedElements
		detect: [ :any | any isKindOf: OPBPMNEdgeLabel  ]
		ifFound: [ ^ self ].
	OPBPMNEdgeLabel in: self forModelElement: self modelElement"
	OPBPMNFlowShape in: self
]

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

	^ (self source = self target
		   ifTrue: [ OPRSBezier ]
		   ifFalse: [ OPRSPolyline ]) new
		  markerEnd: self headMarker;
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
