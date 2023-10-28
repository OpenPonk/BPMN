Class {
	#name : #OPBPMNFlowShape,
	#superclass : #OPEdge,
	#instVars : [
		'shape'
	],
	#category : #'OpenPonk-BPMN-Shapes'
}

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> borderColor: aColor [

	shape color: aColor.
]

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	OPBPMNEdgeLabel in: self
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
	shape := (self source = self target
		   ifTrue: [ OPRSBezier ]
		   ifFalse: [ OPRSPolyline ]) new
		  markerStart: self tailMarker;
		  markerEnd: self headMarker;
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself.
	^ shape
]

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> tailMarker [

	self modelElement ifNil: [ 
		^ (RSShapeFactory polygonWithPoints: (Array with: 0 @ 0))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Normal' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints: (Array with: 0 @ 0))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Conditional' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints: (Array
					    with: 0 @ 20
					    with: 6 @ 10
					    with: 0 @ 0
					    with: -6 @ 10))
			  color: Color black;
			  yourself ].
	self modelElement type = 'Default' ifTrue: [ 
		^ (RSShapeFactory polygonWithPoints:
				   (Array with: 6 @ 12 with: 6 @ 10 with: -6 @ 20 with: -6 @ 22 ))
			  color: Color black;
			  yourself ]
]

{ #category : #'as yet unclassified' }
OPBPMNFlowShape >> updateRenderFromModel [

	shape markerStart: self tailMarker.
	super updateRenderFromModel
]
