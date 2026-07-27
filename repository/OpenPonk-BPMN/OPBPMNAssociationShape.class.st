Class {
	#name : 'OPBPMNAssociationShape',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'hooks' }
OPBPMNAssociationShape >> headMarker [

	self modelElement ifNotNil: [ :model |
		model isToTarget ifTrue: [ ^ OPRSMarkerBuilder arrow ] ].

	^ nil
]

{ #category : 'rendering' }
OPBPMNAssociationShape >> renderBasicShape [

	^ OPRSPolyline new
		  markerStart: self tailMarker;
		  markerEnd: self headMarker;
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
		markerStart: self tailMarker;
		markerEnd: self headMarker.
	super updateRenderFromModel
]
