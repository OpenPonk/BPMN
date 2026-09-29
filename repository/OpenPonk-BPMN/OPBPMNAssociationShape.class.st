"
I am an edge shape representing a BPMN Association. I render as a dashed line connecting an artifact (like an annotation or data object) to a flow node, applying appropriate directional markers.
"
Class {
	#name : 'OPBPMNAssociationShape',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPBPMNAssociationShape >> colorMarker: aMarker [

	aMarker ifNil: [ ^ aMarker ].
	self isRendered ifFalse: [ ^ aMarker ].
	aMarker shape color: self roassalShape color.
	^ aMarker
]

{ #category : 'hooks' }
OPBPMNAssociationShape >> headMarker [

	self modelElement ifNotNil: [ :model |
		model isToTarget ifTrue: [ ^ OPRSMarkerBuilder arrow ] ].

	^ nil
]

{ #category : 'rendering' }
OPBPMNAssociationShape >> renderBasicShape [

	^ OPRSPolyline new
		  dashed;
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]

{ #category : 'rendering' }
OPBPMNAssociationShape >> renderShapeDetails [

	super renderShapeDetails.

	self source associationCreated: self.
	self target associationCreated: self
]

{ #category : 'hooks' }
OPBPMNAssociationShape >> tailMarker [

	self modelElement ifNotNil: [ :model |
		model isToSource ifTrue: [ ^ OPRSMarkerBuilder arrow ] ].

	^ nil
]

{ #category : 'rendering' }
OPBPMNAssociationShape >> updateRenderFromModel [

	roassalShape
		markerStart: (self colorMarker: self tailMarker);
		markerEnd: (self colorMarker: self headMarker).
	super updateRenderFromModel.
	roassalShape signalUpdate
]
